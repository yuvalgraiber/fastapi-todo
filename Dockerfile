# --- Stage 1: The Builder Stage ---
# This stage is now primarily used to copy the requirements file.
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

# ********** CRITICAL FIX FOR pydantic_core COMPATIBILITY **********
# Copy requirements.txt and install dependencies directly in the final stage.
# This ensures that packages like pydantic_core are compiled correctly for the Debian base.
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# ******************************************************************

# Copy the application source code to the working directory
# We assume main.py and other files are in the current local folder.
COPY . .

# Expose the port Uvicorn will listen on
EXPOSE 8000

# The command to run the application when the container starts
# We use the full path to Uvicorn to avoid any potential PATH issues.
CMD ["/usr/local/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
