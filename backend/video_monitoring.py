import cv2
import numpy as np
import pytesseract
import yt_dlp
import time
from PIL import Image
import datetime
import os

def preprocess_image(img):
    """Pré-processamento suave para melhorar a detecção de números digitais"""
    
    # Converter para escala de cinza
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    return gray

def validate_number(current_num, last_num, max_variation=5):
    # validates the actual numer based on the last detected number "
    
    # if there is not a previous number, we accept the actual
    if not last_num:
        return current_num, True
    
    # if there is not a actual number, we keep the last one
    if not current_num:
        return last_num, False
    
    try:
        # convert it to intergers to compare
        current_int = int(current_num)
        last_int = int(last_num)
        
        # verify if the variation is recpecting the acceptable limit
        if abs(current_int - last_int) > max_variation:
            # if the variation is above the limit, the previous number is kept
            return last_num, False
        else:
            # if its an acceptable variation, uses the actual number
            return current_num, True
    except ValueError:
        # in case an error ocurs during convertion, keep the last read number
        return last_num, False

def extract_num(url_youtube, x, y, width, height, interval=10, playback_speed=2.0, max_variation=5):
    try:
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        log_dir = f"extraction_session_{timestamp}"
        os.makedirs(log_dir, exist_ok=True)
        
        ydl_opts = {
            'format': 'best[ext=mp4]',
            'quiet': True
        }
        
        print(f"Obtendo URL para: {url_youtube}")
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url_youtube, download=False)
            stream_url = info['url']
            video_title = info.get('title', 'Vídeo desconhecido')
        
        print(f"URL do stream obtida com sucesso!")
        print(f"Título: {video_title}")
        print(f"Velocidade: {playback_speed}x")
        print(f"Variação máxima permitida: {max_variation}")
        
        log_filename = os.path.join(log_dir, "numeros_detectados.txt")
        with open(log_filename, "w") as log_file:
            log_file.write(f"Extração de: {video_title}\n")
            log_file.write(f"Início: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            log_file.write(f"Variação máxima permitida: {max_variation}\n")
            log_file.write("Timestamp | Número | Observação\n")
            log_file.write("-" * 50 + "\n")
        
        cap = cv2.VideoCapture(stream_url)
        
        if not cap.isOpened():
            raise Exception("Não foi possível abrir o stream")
            
        print(f"Stream iniciado. Extraindo números da região ({x}, {y}, {width}, {height})...")
        print(f"Verificando a cada {interval} segundos. Pressione 'q' para sair.")
        
        next_check_time = time.time()  # verifies imediately (first try)
        last_num = ""
        frames_to_skip = int(playback_speed) - 1 if playback_speed > 1 else 0
        
        while True:
            current_time = time.time()
            
            ret, frame = cap.read()
            
            if not ret:
                print("Não foi possível ler o frame - reconectando...")
                cap.release()
                time.sleep(2)
                
                with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                    info = ydl.extract_info(url_youtube, download=False)
                    stream_url = info['url']
                
                cap = cv2.VideoCapture(stream_url)
                continue
            
            if frames_to_skip > 0:
                for _ in range(frames_to_skip):
                    skip_ret, _ = cap.read()
                    if not skip_ret:
                        break
            
            if y+height <= frame.shape[0] and x+width <= frame.shape[1]:
                roi = frame[y:y+height, x:x+width]
            else:
                print("Aviso: ROI fora dos limites do frame")
                continue
            
            # Mostrar a região original
            cv2.imshow('Região Monitorada', roi)
            
            if current_time >= next_check_time:
                # Tentar primeiro com a imagem original
                pil_img = Image.fromarray(cv2.cvtColor(roi, cv2.COLOR_BGR2RGB))
                texto_original = pytesseract.image_to_string(pil_img, config='--psm 7 -c tessedit_char_whitelist=0123456789')
                num_original = ''.join(c for c in texto_original if c.isdigit())
                
                # Se não detectar na imagem original, tentar com pré-processamento
                if not num_original:
                    # Aplicar pré-processamento suave
                    processed_roi = preprocess_image(roi)
                    cv2.imshow('Imagem Processada', processed_roi)
                    
                    # Tentar OCR na imagem processada
                    texto = pytesseract.image_to_string(
                        processed_roi, 
                        config='--psm 7 -c tessedit_char_whitelist=0123456789'
                    )
                    num_detected = ''.join(c for c in texto if c.isdigit())
                else:
                    num_detected = num_original
                
                # Validar o número detectado
                valid_num, is_original = validate_number(num_detected, last_num, max_variation)
                
                next_check_time = current_time + (interval / playback_speed)
                time_str = time.strftime('%H:%M:%S')
                
                if valid_num:
                    if not is_original:
                        # Número foi corrigido pela validação
                        print(f"[{time_str}] Número detectado: {num_detected}, mas mantendo: {valid_num} (variação > {max_variation})")
                        with open(log_filename, "a") as log_file:
                            log_file.write(f"{time_str} | {valid_num} | Detectado: {num_detected}, variação muito grande\n")
                    elif valid_num != last_num:
                        # Novo número válido e diferente do último
                        print(f"[{time_str}] Número detectado: {valid_num}")
                        with open(log_filename, "a") as log_file:
                            log_file.write(f"{time_str} | {valid_num} | Número válido\n")
                        
                    else:
                        # Mesmo número que antes
                        print(f"[{time_str}] Número detectado: {valid_num} (sem alteração)")
                    
                    last_num = valid_num
                else:
                    # Nenhum número detectado
                    if last_num:
                        print(f"[{time_str}] Nenhum número detectado, mantendo último: {last_num}")
                        with open(log_filename, "a") as log_file:
                            log_file.write(f"{time_str} | {last_num} | Nenhum número detectado, mantendo anterior\n")
                    else:
                        print(f"[{time_str}] Nenhum número detectado")
                        with open(log_filename, "a") as log_file:
                            log_file.write(f"{time_str} | - | Nenhum número detectado\n")
            
            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):
                print("Saindo - tecla 'q' pressionada")
                break
                
            # Pequena pausa para não sobrecarregar a CPU
            time.sleep(0.01)
        
        # Liberar recursos
        cap.release()
        cv2.destroyAllWindows()
        
        print(f"Processamento concluído! Log salvo em: {log_filename}")
        
    except Exception as e:
        print(f"Erro: {e}")


if __name__ == "__main__":
    url_video = "https://www.youtube.com/watch?v=JmzGjuy5x2A&t=13s"
    
    # Região de interesse
    x = 1
    y = 264
    width = 57
    height = 29
    
    interval = 10  # segundos
    playback_speed = 2.0  # Velocidade 2x
    max_variation = 2  # Variação máxima permitida
    
    extract_num(url_video, x, y, width, height, interval, playback_speed, max_variation)