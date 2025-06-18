'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student:
Description: Project 3 - Heart Attack Predictor
'''

from app import heart_attack_predictor
from flask import render_template, redirect, url_for, request
from flask_login import current_user, login_required, login_user, logout_user
from app.models import User
from app.forms import SignUpForm, LoginForm, PatientForm
import bcrypt
import requests
from app.utils import *

@app.route('/')
def index(): 
    return render_template('index.html')

@app.route('/users/signup', methods=['GET', 'POST'])
def signup():
    form = SignUpForm()
    if form.validate_on_submit():
        if form.password.data == form.password_confirm.data:
            hashed_password = bcrypt.hashpw(form.password.data.encode('utf-8'), bcrypt.gensalt())
            try: 
                create_user(
                    form.id.data,
                    name=form.name.data, 
                    email=form.email.data,
                    password=hashed_password
                )
            except Exception as ex: 
                return f'<p>There was an error creating the user: {ex}</p>' 
            return redirect(url_for('index'))
    return render_template('signup.html', form=form)

@app.route('/users/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        try: 
            user = retrieve_user(form.id.data)
            if user and bcrypt.checkpw(form.password.data.encode(), user.password):
                login_user(user)
                app.logger.info(f'A new user with id {user.id} has successfully logged in')
                return redirect(url_for('patient'))
        except Exception as ex: 
            return f'<p>There was an error retrieving the user: {ex}</p>'
    return render_template('login.html', form=form)

@app.route('/patient', methods=['GET', 'POST'])
@login_required
def patient():
    form = PatientForm()
    if form.validate_on_submit():
        data = [
            [ 
                form.age.data, 
                form.gender.data, 
                form.cp.data, 
                form.trestbps.data, 
                form.chol.data, 
                form.fbs.data, 
                form.restecg.data, 
                form.thalach.data, 
                form.exang.data, 
                form.oldpeak.data
            ]
        ]
        print(data)
        prediction = heart_attack_predictor.predict(data)
        if prediction[0] == 0: 
            return '<p>There is no indication of an imminent heart attack.</p>'
        else: 
            return '<h2>This patient is at high risk of an imminent heart attack!</h2>'
    return render_template('patient.html', form=form)

@app.route('/users/signout', methods=['GET', 'POST'])
@login_required
def signout():
    logout_user()
    return redirect(url_for('index'))