from PIL import Image
import numpy as np
import os
import random
import io
import math
import cv2

def load_random_photo(folder):
    files = os.listdir(folder)
    random_file = random.choice(files)
    photos = os.listdir(folder+"/"+random_file)
    random_photo = random.choice(photos)
    img = Image.open(folder+"/"+random_file+"/"+random_photo)
    
    new_size = (322, 322)
    img = img.resize(new_size)

    image = np.array(img)  # Konwertuj obraz PIL na numpy array
    image = image / 255.0  # Znormalizuj wartości pikseli do zakresu [0, 1]
    image = np.expand_dims(image, axis=0)  # Dodaj dodatkowy wymiar do obsługi wsadu
    
    class_img=random_file[0]
    return image, class_img


def load_random_photo_from_cat(folder, cat):
    photos = os.listdir(folder+"/"+cat)
    random_photo = random.choice(photos)
    img = Image.open(folder+"/"+cat+"/"+random_photo)
    
    new_size = (322, 322)
    img = img.resize(new_size)

    image = np.array(img)  # Konwertuj obraz PIL na numpy array
    image = image / 255.0  # Znormalizuj wartości pikseli do zakresu [0, 1]
    image = np.expand_dims(image, axis=0)  # Dodaj dodatkowy wymiar do obsługi wsadu
    
    return image

def transform_photo(img):
    new_img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    return new_img