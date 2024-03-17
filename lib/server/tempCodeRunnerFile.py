from fastapi import FastAPI
from pydantic import BaseModel
import joblib

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
    # Convert input features to numpy array
    features = [[item.distance, item.category, item.type, item.status]]
    # Make prediction using the loaded model
    prediction = model.predict(features)
    return {"prediction": prediction.tolist()}
