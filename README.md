# DevOps ToDo API

This is a simple FastAPI To-Do application built as part of a DevOps CI/CD pipeline tutorial.

## Project Stack
* **Framework**: FastAPI (Python)
* **Containerization**: Docker
* **CI/CD Target**: AWS (CodePipeline, ECR, ECS/EC2)

## Local Run Instructions
1. Build the Docker image:
   ```bash
   docker build -t todo-api:v1 .
   ```
2. Run the container:
   ```bash
   docker run -d --name todo-container -p 80:8000 todo-api:v1
   ```
3. Access the API documentation at: http://localhost/docs
