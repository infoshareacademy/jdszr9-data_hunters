import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics import confusion_matrix
from seaborn import heatmap

def plot_history(history):
    fig, ax = plt.subplots(nrows=2,ncols=2, figsize=(20,10))
    # wyświetlamy wykresy
    ax[0][0].plot(history.history["loss"])
    ax[0][1].plot(history.history["accuracy"])
    ax[1][0].plot(history.history["val_loss"])
    ax[1][1].plot(history.history["val_accuracy"])
    #nazywamy zdjęcia
    ax[0][0].set_title("train loss")
    ax[0][1].set_title("train accuracy")
    ax[1][0].set_title("validation loss")
    ax[1][1].set_title("validation accuracy")
    plt.show()
    
def print_confusion_matrix(y_true, y_pred, title, categories):
    cm = confusion_matrix(y_true, y_pred)

    ax = heatmap(cm, annot=True, fmt="d", cmap="Blues", xticklabels=categories, yticklabels=categories)
    ax.set_xlabel('Predicted labels')
    ax.set_ylabel('True labels')
    ax.set_title(title)
    
def get_y_pred(model, test_generator):  
    
    predictions = model.predict_generator(test_generator, steps=len(test_generator), verbose=1)
    return np.argmax(predictions, axis=1)
