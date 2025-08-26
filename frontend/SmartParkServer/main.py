from fastapi import FastAPI, UploadFile, File, Form, HTTPException, BackgroundTasks
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os
import shutil
import uuid
from typing import Annotated

# Assuming ParkingSpotDetector and ExperienceLevel are correctly defined in controller.py
from controller import ParkingSpotDetector, ExperienceLevel

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name='static')

@app.get("/favicon.ico", include_in_schema=False)
async def icon():
    return FileResponse("static/favicon.png")

@app.get("/")
async def home_root():
    return {"name": "kailash"}

UPLOAD_DIRECTORY = "images"

# Helper function to delete a specific file
def delete_uploaded_file(path: str):
    if os.path.exists(path) and os.path.isfile(path):
        try:
            os.remove(path)
            print(f"File '{path}' deleted successfully.")
        except OSError as error:
            print(f"Error deleting file: {error}")
    else:
        print(f"Path '{path}' does not exist or is not a file.")

# Ensure the upload directory exists once at startup
os.makedirs(UPLOAD_DIRECTORY, exist_ok=True)

# Fixed: Remove trailing slash to match client requests
@app.post("/upload_image")
async def upload_image(
    background_tasks: BackgroundTasks,
    image: UploadFile = File(...),
    prefer_entrance: Annotated[bool, Form()] = False,
    prefer_exit: Annotated[bool, Form()] = False,
    experience: Annotated[int, Form()] = -1
):
    # Check for empty file
    if not image.filename:
        raise HTTPException(status_code=400, detail="No image file was provided.")
    
    file_path = None
    best_spot = None
    image_response = None

    try:
        # Fixed: Use unique filename to prevent conflicts
        file_extension = os.path.splitext(image.filename)[1]
        prefix_name = uuid.uuid4()
        unique_filename = f"{prefix_name}{file_extension}"
        file_path = os.path.join(UPLOAD_DIRECTORY, unique_filename)

        print("Writing file...")
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
        print("End of writing file.")

        # Determine the experience level from the integer input
        experience_level = None
        if experience == 0:
            experience_level = ExperienceLevel.BEGINNER
        elif experience == 1:
            experience_level = ExperienceLevel.INTERMEDIATE
        elif experience >= 2:
            experience_level = ExperienceLevel.EXPERT
        # else: experience_level remains None

        print(unique_filename)

        detector = ParkingSpotDetector(
            model_path="static/model.pt",
            entrance_coords=(0, 200),
            exit_coords=(610, 200),
            result=file_path,
            filename= prefix_name
        )

        best_spot = detector.start(
            entrance=prefer_entrance,
            exit=prefer_exit,
            experience=experience_level,
            file_path=file_path
        ) 

    except Exception as e:
        print(f"Upload image error: {e}")
        # Re-raise as HTTPException to provide a proper error response
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {e}")
    finally:
        # Fixed: Close file properly
        if hasattr(image, 'file') and image.file:
            image.file.close()
        # Schedule the uploaded file for deletion after processing
        if file_path:
            image_response = FileResponse(f"images/{prefix_name}_output{file_extension}")
            image_response.headers["best_spot"] = str(best_spot)
            background_tasks.add_task(delete_uploaded_file, file_path)
            background_tasks.add_task(delete_uploaded_file, f"images/{prefix_name}_output{file_extension}")

    return image_response 