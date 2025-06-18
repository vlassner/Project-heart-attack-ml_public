[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/r4pmGJ51)
# Overview

In the United States, someone experiences a heart attack every 40 seconds, contributing to more than 800K heart attacks annually. This underscores the critical need for awareness and prevention. Regularly assessing your risk of suffering a heart attack is crucial, as it allows for timely interventions and lifestyle changes that can significantly reduce the likelihood of life-threatening cardiovascular events.

In this project, you are tasked with implementing a web app that enables doctors to assess the risk of a patient having a heart attack. The web app will be powered by a machine learning model trained on a real-world dataset containing patient information.

# Instructions

## Dataset 

The [data/heart_attack.csv](data/heart_attack.csv) contains the following information about 261 patients: 

* Age: The age of the patient (e.g., 28 years).
* Sex: The gender of the patient (1 = male, 0 = female).
* CP (Chest Pain Type): The type of chest pain experienced (0 = typical angina, 1 = atypical angina, 2 = non-anginal pain, 3 = asymptomatic).
* Trestbps (Resting Blood Pressure): The patient's resting blood pressure in mm Hg (e.g., 130 mm Hg).
* Chol (Serum Cholesterol): The patient's serum cholesterol in mg/dL (e.g., 132 mg/dL).
* FBS (Fasting Blood Sugar): Whether the patient's fasting blood sugar is > 120 mg/dL (1 = true, 0 = false).
* Restecg (Resting Electrocardiographic Results): The results of the resting ECG (0 = normal, 1 = having ST-T wave abnormality, 2 = showing probable or definite left ventricular hypertrophy).
* Thalach (Maximum Heart Rate Achieved): The maximum heart rate achieved during exercise (e.g., 185 bpm).
* Exang (Exercise Induced Angina): Whether the patient experienced angina during exercise (1 = yes, 0 = no).
* Oldpeak: The ST depression induced by exercise relative to rest (e.g., 0).
* Heart Attack: Whether the patient is at risk of having a heart attack (1 = yes, 0 = no).

## Part 1

Using the provided template in [part1](part1), write Terraform code to create an S3 bucket and upload [data/heart_attack.csv](data/heart_attack.csv) to it. Also, the code should create a SageMaker domain and a (profile) user, both having the necessary permissions for the training of your machine learning model. 

## Machine Learning Model

After the cloud infrastructure is created, create a JupyterLab Space and upload [src/main.ipynb](src/main.ipynb) to it. Finish the to-do's embedded in the Python notebook, including the part that serializes your model (and the scaler) for future use in your web app to make predictions. We suggest using Python's [joblib](https://joblib.readthedocs.io/en/stable/) to do the serialization. 

When you are done building your ML model and serializing it, download both **main.ipynb** notebook and the serialized files **logist_mode.pkl** and **scaler.pkl**. You need to push both files to GitHub to get full credit on this assignment. Once you are done downloading those files you can destroy the infrastructure built for part 1. 

## Part 2 

Using the provided template in [part2](part2), write Terraform code to create a PostgreSQL database using RDS for authenticating the users of the web app. Update the text below with the ARN and public IP of your postgres RDS instance. 

```
rds_instance_arn = "arn:aws:rds:us-west-1:060795946302:db:webapp-postgres-db"
rds_instance_public_ip = "webapp-postgres-db.cha2woco0an7.us-west-1.rds.amazonaws.com"
```

## Web App Deployment

The code for the web app is given to you. Update [config.ini](config.ini) with your own database **host** value and credentials. Build a Docker image and push it to ECR.

```
docker build --platform linux/amd64 -t prj-03 .
```

docker run --rm --name prj-03 --publish 5000:5000 prj-03

Replace ```<YOUR-ACCOUNT-ID>``` accordingly. 

```
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 060795946302.dkr.ecr.us-west-1.amazonaws.com 

docker tag prj-03 060795946302.dkr.ecr.us-west-1.amazonaws.com/dsml3850:prj-03

docker push 060795946302.dkr.ecr.us-west-1.amazonaws.com/dsml3850:prj-03
```

## Part 3: ECS Deployment

Complete [part3](part3) Terraform coding to deploy the web app using ECS. To get full credit on this assignment you need to provide the public IP of your ECS service. 

```
Public IP (or name endpoint) of ECS service: 13.52.78.215
```

# Rubric

```
+20 part 1 Terraform code (to build the environment to create the ML model)
+20 Jupyter Notebook source code properly creates the model
+5 logistic_model.pkl serialization file
+5 scaler.pkl serialization file
+15 part 2 Terraform code (to create the database for authentication purposes)
+10 Dockerfile to build the web app Docker image
+25 part 3 Terraform code (to deploy the web app using the container service in the cloud) 
```