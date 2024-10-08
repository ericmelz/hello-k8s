# Use an official Python runtime as a parent image
FROM python:3.11-bullseye

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY src /app/src

# Expose port 8000 to the outside world
EXPOSE 8000

# Define environment variable for production
ENV greeting="Hello k8s from docker!"

# Set the working directory to /app/src/api
WORKDIR /app/src/api

# Run the FastAPI service using Uvicorn
CMD ["uvicorn", "greet:app", "--host", "0.0.0.0", "--port", "8000"]