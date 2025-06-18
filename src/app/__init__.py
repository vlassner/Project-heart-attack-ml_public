'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student:
Description: Project 3 - Heart Attack Predictor
'''

from flask import Flask
import configparser as cp

app = Flask('Heart Attack Predictor')

# consider using an ENVIRONMENT VARIABLE to improve security
app.secret_key = 'you-will-never-guess'

# db initialization
print('db initialization started')
config = cp.RawConfigParser()
config.read('config.ini')
params = dict(config.items('db'))
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{params['user']}:{params['password']}@{params['host']}:{params['port']}/postgres"
db.init_app(app)
print('db initialization completed!')

# db from models
from app import models
with app.app_context():
    db.create_all()

# login manager
from flask_login import LoginManager
login_manager = LoginManager()
login_manager.init_app(app)

from app.models import User

# user_loader callback
@login_manager.user_loader
def load_user(id):
    try: 
        return db.session.query(User).filter(User.id==id).one()
    except: 
        return None
    
# Heart attack predictor
heart_attack_predictor = models.HeartAttackPredictor()

from app import routes
  