from typing import Optional, List
from pydantic import BaseModel
from fastapi import FastAPI, HTTPException

# --- 1. Define the Data Model using Pydantic ---
class Task(BaseModel):
    id: Optional[int] = None
    title: str
    description: Optional[str] = None
    completed: bool = False

# --- 2. In-Memory Database and Counter ---
tasks_db: List[Task] = []
next_id = 1

# --- 3. Initialize FastAPI Application ---
app = FastAPI(title="DevOps To-Do API", version="1.0.0")

# --- 4. CRUD Endpoints ---

@app.post("/tasks", response_model=Task, status_code=201)
def create_task(task: Task):
    """
    Creates a new To-Do task and assigns it a unique ID.
    """
    global next_id
    
    task.id = next_id
    next_id += 1
    
    tasks_db.append(task)
    return task

@app.get("/tasks", response_model=List[Task])
def read_tasks():
    """
    Retrieves the list of all To-Do tasks in the database.
    """
    return tasks_db

@app.get("/tasks/{task_id}", response_model=Task)
def read_task(task_id: int):
    """
    Retrieves a single To-Do task by its unique ID.
    """
    for task in tasks_db:
        if task.id == task_id:
            return task
    
    raise HTTPException(status_code=404, detail="Task not found")

@app.put("/tasks/{task_id}", response_model=Task)
def update_task(task_id: int, updated_task: Task):
    """
    Updates an existing To-Do task by its ID.
    """
    for index, task in enumerate(tasks_db):
        if task.id == task_id:
            tasks_db[index].title = updated_task.title
            tasks_db[index].description = updated_task.description
            tasks_db[index].completed = updated_task.completed
            tasks_db[index].id = task_id 
            return tasks_db[index]
    
    raise HTTPException(status_code=404, detail="Task not found")

@app.delete("/tasks/{task_id}", status_code=204)
def delete_task(task_id: int):
    """
    Deletes a To-Do task by its unique ID. 
    """
    global tasks_db
    
    initial_length = len(tasks_db)
    tasks_db = [task for task in tasks_db if task.id != task_id]
    
    if len(tasks_db) == initial_length:
        raise HTTPException(status_code=404, detail="Task not found")
    
    return