FROM python:3.11
 
WORKDIR /app
 
COPY requirements.txt .
RUN pip install -r requirements.txt
 
ADD src/app /app
ADD static /app/static
ADD templates /app/templates/
ADD config.ini /app
COPY logistic_model.pkl /app
ADD scaler.pkl /app
 
EXPOSE 5000
 
ENV FLASK_APP=/app
 
CMD ["flask", "run", "-h", "0.0.0.0", "--debug"]