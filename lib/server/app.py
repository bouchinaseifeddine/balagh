from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import pandas as pd

# Load the trained scikit-learn model
model = joblib.load('score_system.pkl')

# Define input schema using Pydantic BaseModel
class Item(BaseModel):
    distance: float
    category: int
    type: int
    status: int

# Create FastAPI app instance
app = FastAPI()

# Define prediction endpoint
@app.post("/predict/")
async def predict(item: Item):
    # Convert input features to DataFrame
    input_data = pd.DataFrame({'distance': [item.distance],
                               'category': [item.category],
                               'type': [item.type],
                               'status': [item.status]})
    
    # Print input_data before one-hot encoding
    print("Input data before one-hot encoding:")
    print(input_data)
    
    # Apply one-hot encoding
    input_data_encoded = pd.get_dummies(input_data)
    
    # Get missing columns in input_data_encoded and set them to zero
    missing_cols = set(X_encoded.columns) - set(input_data_encoded.columns)
    for col in missing_cols:
        input_data_encoded[col] = 0
    
    # Reorder columns to match the training data
    input_data_encoded = input_data_encoded[X_encoded.columns]
    
    # Print input_data after one-hot encoding
    print("Input data after one-hot encoding:")
    print(input_data_encoded)
    
    # Make prediction using the loaded model
    prediction = model.predict(input_data_encoded)
    return {"prediction": prediction.tolist()}
