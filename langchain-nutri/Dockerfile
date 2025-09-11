# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose port 5000 for the Flask application
EXPOSE 5000

# Run the app with a production-ready WSGI server
# We'll use Gunicorn, which is more robust than Flask's built-in server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
