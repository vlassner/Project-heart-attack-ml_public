'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student:
Description: Project 3 - Heart Attack Predictor
'''

from app import db 
from flask_login import UserMixin
import joblib

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.String, primary_key=True)
    name = db.Column(db.String)
    email = db.Column(db.String)
    password = db.Column(db.LargeBinary)

class HeartAttackPredictor(): 
    
    def __init__(self):

        # Load the model from the file
        self.model = joblib.load('logistic_model.pkl')

        # Load the scaler from the file 
        self.scaler = joblib.load('scaler.pkl')

    def predict(self, data):

        # Scale the data
        data_scaled = self.scaler.transform(data)

        # Make prediction
        prediction = self.model.predict(data_scaled)

        return prediction



                                 

