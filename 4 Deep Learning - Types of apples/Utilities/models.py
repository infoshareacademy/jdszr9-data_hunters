import tensorflow as tf
from tensorflow.keras import layers
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Activation, Dropout

def load_netv2_model (input_shape, num_outputs):
    inputLayer = tf.keras.Input(shape=(input_shape))
    # bierzemy wytrenowany wcześniej model
    base_model = tf.keras.applications.mobilenet_v2.MobileNetV2(
    weights='imagenet',  # wczytaj z nauczonymi wagami
    input_shape=input_shape,
    include_top=False)   # nie dołączaj ostatniej warstwy k\

    # nie chcemy aby nauczony już feature extractor się uczył
    base_model.trainable = False\

    # dodajemy ostatnie warstwy klasyfikatora
    x = base_model(inputLayer, training=False)
    x = layers.GlobalAveragePooling2D()(x)
    x = layers.Dropout(0.2)(x)
    output = layers.Dense(6, activation="softmax")(x)

    # zamykamy w kerasowy model
    model_2 = tf.keras.Model(inputLayer, output)
    model_2.summary()

    # kompilujemy całość
    model_2.compile(loss='categorical_crossentropy',optimizer='adam',metrics=['accuracy'])
    return model_2
    
def create_model(input_shape, num_outputs):
    shape_img = input_shape
    
    model = Sequential()
    
    model.add(Conv2D(filters=32, kernel_size=(3,3),input_shape=shape_img, activation='relu', padding = 'same'))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Conv2D(filters=64, kernel_size=(3,3),input_shape=shape_img, activation='relu', padding = 'same'))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Conv2D(filters=64, kernel_size=(3,3),input_shape=shape_img, activation='relu', padding = 'same'))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Conv2D(filters=64, kernel_size=(3,3),input_shape=shape_img, activation='relu', padding = 'same'))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    
    model.add(Conv2D(filters=64, kernel_size=(3,3),input_shape=shape_img, activation='relu', padding = 'same'))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Flatten())

    model.add(Dense(322))
    model.add(Activation('relu'))
    model.add(Dropout(0.5))

    model.add(Dense(num_outputs))
    model.add(Activation('softmax'))

    model.compile(loss='categorical_crossentropy',optimizer='adam',metrics=['accuracy'])
    
    return model

def load_model(name):
    return tf.keras.models.load_model(name)