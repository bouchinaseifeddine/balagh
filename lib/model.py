import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.metrics import r2_score

dataset = pd.read_csv('/content/dataset-1.csv',sep=",")

X = dataset[['distance', 'category', 'type', 'status']]
Y = dataset['points']


X_encoded = pd.get_dummies(X)


X_train, X_test, Y_train, Y_test = train_test_split(X_encoded, Y, test_size=0.2)


poly = PolynomialFeatures(degree=2)
X_train_poly = poly.fit_transform(X_train)
X_test_poly = poly.transform(X_test)


poly_reg = LinearRegression()
poly_reg.fit(X_train_poly, Y_train)


Y_pred = poly_reg.predict(X_test_poly)
Y_pred

prediction = poly.fit_transform([[11,1,0,1,0,0,0,0,0,0,0,0,0,2]]) #real point = 7
poly_reg.predict(prediction)

mse = mean_squared_error(Y_test, Y_pred)
mse

r2 =r2_score(Y_test, Y_pred)
r2