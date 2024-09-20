# Use an official Python runtime as a parent image
FROM python:3.11-bullseye

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y default-mysql-client && \
    pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY src/api /app/api
COPY src/migrations /app/migrations
COPY src/alembic.ini /app/alembic.ini

# Expose port 8000 to the outside world
EXPOSE 8000

# Define environment variable for production
ENV DATABASE_URL="mysql://hellouser:hellopass@localhost/hello"
ENV greeting="Hello k8s from docker!"

# Run Alembic migrations
#RUN alembic upgrade head

# Set the working directory to /app
WORKDIR /app

# Run the FastAPI service using Uvicorn
CMD ["uvicorn", "api.greet:app", "--host", "0.0.0.0", "--port", "8000"]