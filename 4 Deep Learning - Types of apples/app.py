
import streamlit as st
import pandas as pd
from PIL import Image
import tensorflow as tf
import numpy as np
import os
import random
import io
import math
from Utilities.load_photos import load_random_photo, load_random_photo_from_cat

def main():
    # Tworzenie siatki 2 x 3
    cols = st.columns(3)
    source='data/test'
    # Pierwszy wiersz
    with cols[0]:
        cat='A'
        img1=load_random_photo_from_cat(source,cat)
        st.image(img1)
        st.caption('Kategoria '+cat)
    
    with cols[1]:
        cat='B'
        img2=load_random_photo_from_cat(source,cat)
        st.image(img2)
        st.caption('Kategoria '+cat)
    
    with cols[2]:
        cat='C'
        img3=load_random_photo_from_cat(source,cat)
        st.image(img3)
        st.caption('Kategoria '+cat)
    
    # Drugi wiersz
    with cols[0]:
        cat='D'
        img4=load_random_photo_from_cat(source,cat)
        st.image(img4)
        st.caption('Kategoria '+cat)
    
    with cols[1]:
        cat='E'
        img5=load_random_photo_from_cat(source,cat)
        st.image(img5)
        st.caption('Kategoria '+cat)
    
    with cols[2]:
        cat='F'
        img6=load_random_photo_from_cat(source,cat)
        st.image(img6)
        st.caption('Kategoria '+cat)
        
konwersja = {0: 'A', 1: 'B', 2: 'C', 3: 'D', 4: 'E', 5: 'F'}

if __name__ == '__main__':
    st.write("Sortownia jabłek")
    main()

    

model = tf.keras.models.load_model('models/my_model.keras')

uploaded_file = st.sidebar.file_uploader("Wybierz plik", type=["png", "jpg"])

if uploaded_file is not None:

    data = uploaded_file.read()

    imgOwn = Image.open(io.BytesIO(data))
    imgOwn = imgOwn.resize((322, 322))
    img_array = np.array(imgOwn)
    img_array = img_array / 255.0

    st.image(imgOwn, caption=f"{uploaded_file.name}")
    prediction = model.predict(np.expand_dims(img_array, axis=0))
    y_pred = np.argmax(prediction, axis=1)
    pred_gatunek = konwersja[y_pred[0]]
    st.text(f"Gatunek: {uploaded_file.name[0]} Predykcja: {pred_gatunek}")