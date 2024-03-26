from fastapi import FastAPI
from sklearn.preprocessing import OneHotEncoder
import joblib
import numpy as np

# Load the trained scikit-learn model
model = joblib.load('score_system.pkl')


# Create FastAPI app instance
app = FastAPI()
encoder = OneHotEncoder()  # Initialize your one-hot encoder


@app.post("/predict/")
async def predict():
    # # Transform 'type' using one-hot encoding
    # type_encoded = encoder.transform([[type]]).toarray()

    # # Prepare input features for prediction
    # features = np.array([[distance, category, status]])
    # features_with_type = np.concatenate((features, type_encoded), axis=1)


    # features_with_type = np.concatenate((features, type_encoded), axis=1)

    # # Make prediction using your model
    # prediction = model.predict(features_with_type)

    # return {"encoded_type": type_encoded.tolist()}
    print(req)
    print(category)
    print(type)
    print(status)
    return {"message": "donne"}

@app.get("/test/")
async def test_endpoint():
    return {"message": "This is a test endpoint"}