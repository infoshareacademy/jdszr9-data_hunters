import os
import random
import shutil

def split_to_train_test(folder):
    train_dir = folder + "train"
    test_dir = folder + "test"
    os.mkdir(test_dir)
    os.mkdir(train_dir)
    for name in categories:
        photo_dir = folder + "Apple/Apple " + name
        photos = os.listdir(photo_dir)
        os.mkdir(os.path.join(train_dir, name))
        os.mkdir(os.path.join(test_dir, name))
        for idx, photo in enumerate(photos):
            if random.random() < 0.9:
                dest_dir = train_dir
            else:
                dest_dir = test_dir
            src_path = os.path.join(photo_dir, photo)
            dest_path = os.path.join(dest_dir, name, photo)
            shutil.copy(src_path, dest_path)