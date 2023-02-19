import pandas as pd
import numpy as np
import pickle
import time

from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix, classification_report

import xgboost as xgb
from xgboost import plot_importance

import warnings
warnings.filterwarnings('ignore')

x_train = pd.read_csv('datasets/x_train.csv', header = None).to_numpy()
y_train = np.ravel(pd.read_csv('datasets/y_train.csv', header = None).to_numpy())
x_test = pd.read_csv('datasets/x_test.csv', header = None).to_numpy()
y_test = np.ravel(pd.read_csv('datasets/y_test.csv', header = None).to_numpy())

logReg = LogisticRegression(class_weight = 'balanced')
model = logReg.fit(x_train, y_train)

start = time.time()
y_pred = model.predict(x_test)
end = time.time()
print("Tiempo en predicción:", end - start, "[s]")

confusion_matrix(y_test, y_pred)


print(classification_report(y_test, y_pred))

report = classification_report(y_test, y_pred, output_dict=True)
report.update({"accuracy": {"precision": None, "recall": None, "f1-score": report["accuracy"], "support": report['macro avg']['support']}})
df = pd.DataFrame(report).transpose()

#Generar pickle file
file = open ("modelnew.pkl","wb")
pickle.dump(df, file)

