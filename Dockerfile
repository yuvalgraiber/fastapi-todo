# --- Stage 1: The Builder Stage ---
FROM python:3.11-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# --- Stage 2: The Final Stage (Runtime Image) ---
# Use a secure, smaller base image (Debian/Buster) for runtime
FROM python:3.11-slim-buster

# Environment variable to prevent Python buffering output (crucial for logs)
ENV PYTHONUNBUFFERED=1

# Set the main working directory for the application
WORKDIR /app 

# Copy requirements.txt and install dependencies directly in the final stage.
# This ensures that packages like pydantic_core are compiled correctly for the Debian base.
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# ******************************************************************
#adding curl command
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*
# Copy the application source code to the working directory
# We assume main.py and other files are in the current local folder.
COPY . .

# Expose the port Uvicorn will listen on
EXPOSE 8000

# The command to run the application when the container starts
# use the full path to Uvicorn to avoid any potential PATH issues.
CMD ["/usr/local/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
