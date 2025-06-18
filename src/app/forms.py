'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student:
Description: Project 3 - Heart Attack Predictor
'''

from flask_wtf import FlaskForm
from wtforms import PasswordField, StringField, EmailField, SubmitField, IntegerField, SelectField, FloatField
from wtforms.validators import DataRequired

class SignUpForm(FlaskForm):
    id = StringField('Id', validators=[DataRequired()])
    name = StringField('Name', validators=[DataRequired()])
    email = EmailField('Email', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    password_confirm = PasswordField('Confirm Password', validators=[DataRequired()])
    submit = SubmitField('Confirm')

class LoginForm(FlaskForm):
    id = StringField('Id', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Confirm')

class PatientForm(FlaskForm):
    age = IntegerField('Age (in years)', validators=[DataRequired()])
    gender = SelectField('Gender', choices=[(1, 'Male'), (0, 'Female')], coerce=int)
    cp = SelectField('CP (Chest Pain Type)', choices=[(1, 'typical angina'), (2, 'atypical angina'), (3, 'non-anginal pain'), (4,'asymptomatic')], coerce=int)
    trestbps = IntegerField('Trestbps (Resting Blood Pressure)', validators=[DataRequired()])
    chol = IntegerField('Chol (Serum Cholesterol)', validators=[DataRequired()])
    fbs = SelectField('FBS (Fasting Blood Sugar)', choices=[(1, 'True'), (0, 'False')], coerce=int)
    restecg = SelectField('Restecg (Resting Electrocardiographic Results)', choices=[(0, 'normal'), (1, 'having ST-T wave abnormality'), (2, 'showing probable or definite left ventricular hypertrophy')], coerce=int)
    thalach = IntegerField('Thalach (Maximum Heart Rate Achieved)', validators=[DataRequired()])
    exang = SelectField('Exang (Exercise Induced Angina)', choices=[(1, 'yes'), (0, 'no')], coerce=int)
    oldpeak = FloatField('Oldpeak (The ST depression induced by exercise relative to rest)', validators=[DataRequired()])
    submit = SubmitField('Confirm')
