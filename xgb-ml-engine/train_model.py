#!/usr/bin/env python
from sklearn import datasets
from sklearn.model_selection import train_test_split
import xgboost as xgb

# Load the Iris dataset
iris = datasets.load_iris()
X = iris.data
y = iris.target

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Load data into DMatrix object
dtrain = xgb.DMatrix(X_train, label=y_train)

# Train XGBoost model
bst = xgb.train({}, dtrain, 20)

bst.save_model('./model.bst')

