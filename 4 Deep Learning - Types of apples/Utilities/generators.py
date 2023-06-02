import os
from keras.preprocessing.image import ImageDataGenerator


def create_generators(folder, batch_size= 56, n_val = 0.0):
    train_data_dir = os.path.join(folder, 'train')

    test_data_dir = os.path.join(folder, 'test')


    # tworzymy obiekt ImageDataGenerator dla danych treningowych
    train_datagen = ImageDataGenerator(rescale=1./255, validation_split= 0.1)

    # tworzymy obiekt ImageDataGenerator dla danych testowych
    test_datagen = ImageDataGenerator(rescale=1./255)

    # generator danych treningowych
    train_generator = train_datagen.flow_from_directory(
            train_data_dir,
            target_size=(322, 322),
            batch_size=batch_size,
            class_mode='categorical',
            subset ="training", 
            shuffle=True
    )

    val_generator = train_datagen.flow_from_directory(
            train_data_dir,
            target_size=(322, 322),
            batch_size=batch_size,
            class_mode='categorical',
            subset ="validation", 
            shuffle=False
    )

    # generator danych testowych
    test_generator = test_datagen.flow_from_directory(
            test_data_dir,
            target_size=(322, 322),
            batch_size=batch_size,
            class_mode='categorical', 
            shuffle=False
    )
    return train_generator, val_generator, test_generator
    
    
    
def create_ultra_test_generator(folder, batch_size= 56):
    ultra_test_dir = os.path.join(folder, 'ultra_test')

    ultra_test_datagen = ImageDataGenerator(rescale=1./255)


    ultra_test_generator = ultra_test_datagen.flow_from_directory(
            ultra_test_dir,
            target_size=(322, 322),
            batch_size=batch_size,
            class_mode='categorical', 
            shuffle=False
    )
    return ultra_test_generator
