from flask import Flask, request, render_template
from PIL import Image
import os

app = Flask(__name__)

def get_image_info(file_path):
    with Image.open(file_path) as img:
        file_name = os.path.basename(file_path)
        width, height = img.size
        dpi = img.info.get('dpi', (0, 0))
        color_depth = img.mode
        color_depth_bits = 8 * len(img.getbands())  # Расчет глубины цвета в битах
        
        # Определяем сжатие, если применимо
        compression = img.info.get('compression', 'N/A')

        # Вычисление уровня сжатия для JPEG файлов
        file_size = os.path.getsize(file_path)
        raw_size = width * height * color_depth_bits / 8
        if img.format == 'JPEG':
            compression_ratio = (file_size / raw_size) * 100
            compression_ratio = f"{compression_ratio:.2f}%"
        else:
            compression_ratio = 'N/A'

        return {
            "Имя файла": file_name,
            "Размер (пиксели)": f"{width}x{height}",
            "Разрешение (dpi)": f"{dpi[0]}x{dpi[1]}",
            "Глубина цвета (бит)": color_depth_bits,
            "Глубина цвета": color_depth,
            "Сжатие": compression,
            "Уровень сжатия (%)": compression_ratio
        }

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_files():
    folder = request.form.get('folder')
    results = []

    for root, dirs, files in os.walk(folder):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                info = get_image_info(file_path)
                results.append(info)
            except Exception as e:
                print(f"Ошибка обработки файла {file_path}: {e}")

    return render_template('index.html', results=results)

if __name__ == "__main__":
    app.run(debug=True)
