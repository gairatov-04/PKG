from flask import Flask, render_template, request, send_file
import cv2
import numpy as np
from io import BytesIO

app = Flask(__name__)

def linear_contrast_stretching(image):
    min_val, max_val = np.min(image), np.max(image)
    stretched = (image - min_val) * (255 / (max_val - min_val))
    return np.uint8(stretched)

def histogram_equalization(image):
    if len(image.shape) == 2:  # Grayscale image
        return cv2.equalizeHist(image)
    else:  # Color image
        img_yuv = cv2.cvtColor(image, cv2.COLOR_BGR2YUV)
        img_yuv[:,:,0] = cv2.equalizeHist(img_yuv[:,:,0])
        return cv2.cvtColor(img_yuv, cv2.COLOR_YUV2BGR)

def histogram_equalization_rgb(image):
    channels = cv2.split(image)
    eq_channels = [cv2.equalizeHist(channel) for channel in channels]
    return cv2.merge(eq_channels)

def histogram_equalization_hsv(image):
    img_hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    img_hsv[:,:,2] = cv2.equalizeHist(img_hsv[:,:,2])
    return cv2.cvtColor(img_hsv, cv2.COLOR_HSV2BGR)

def global_thresholding(image, threshold=127):
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    _, threshed_image = cv2.threshold(gray_image, threshold, 255, cv2.THRESH_BINARY)
    return threshed_image

def local_thresholding(image):
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    threshed_image = cv2.adaptiveThreshold(gray_image, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)
    return threshed_image

def adaptive_thresholding(image):
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    threshed_image = cv2.adaptiveThreshold(gray_image, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 11, 2)
    return threshed_image

def morphological_processing(image, kernel_shape=cv2.MORPH_RECT, kernel_size=(5,5)):
    kernel = cv2.getStructuringElement(kernel_shape, kernel_size)
    morphed_image = cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)
    return morphed_image

def process_image(file, method):
    image = cv2.imdecode(np.fromstring(file.read(), np.uint8), cv2.IMREAD_COLOR)
    if method == 'linear_contrast_stretching':
        processed_image = linear_contrast_stretching(image)
    elif method == 'histogram_equalization':
        processed_image = histogram_equalization(image)
    elif method == 'histogram_equalization_rgb':
        processed_image = histogram_equalization_rgb(image)
    elif method == 'histogram_equalization_hsv':
        processed_image = histogram_equalization_hsv(image)
    elif method == 'global_thresholding':
        processed_image = global_thresholding(image)
    elif method == 'local_thresholding':
        processed_image = local_thresholding(image)
    elif method == 'adaptive_thresholding':
        processed_image = adaptive_thresholding(image)
    elif method == 'morphological_processing':
        processed_image = morphological_processing(image)
    else:
        processed_image = image
    _, img_encoded = cv2.imencode('.png', processed_image)
    return BytesIO(img_encoded)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_image():
    file = request.files['file']
    method = request.form.get('method')
    processed_image = process_image(file, method)
    return send_file(processed_image, mimetype='image/png')

if __name__ == "__main__":
    app.run(debug=True)