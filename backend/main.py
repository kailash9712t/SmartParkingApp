from fastapi import FastAPI, UploadFile, File, Form, HTTPException, BackgroundTasks
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os
import shutil
import uuid
from fastapi.middleware.cors import CORSMiddleware
from typing import Annotated, Optional
import json
from PIL import Image

# Assuming ParkingSpotDetector and ExperienceLevel are correctly defined in controller.py
from controller import ParkingSpotDetector, ExperienceLevel

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to your Flutter app URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static directory
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/favicon.ico", include_in_schema=False)
async def icon():
    return FileResponse("static/favicon.png")

@app.get("/")
async def home_root():
    return {"name": "kailash"}

# Upload directory
UPLOAD_DIRECTORY = "images"
os.makedirs(UPLOAD_DIRECTORY, exist_ok=True)

# Helper function to delete uploaded file
def delete_uploaded_file(path: str):
    if os.path.exists(path) and os.path.isfile(path):
        try:
            os.remove(path)
            print(f"File '{path}' deleted successfully.")
        except OSError as error:
            print(f"Error deleting file: {error}")
    else:
        print(f"Path '{path}' does not exist or is not a file.")

# Upload endpoint
@app.post("/upload_image")
async def upload_image(
    background_tasks: BackgroundTasks,
    image: UploadFile = File(...),
    prefer_entrance: Annotated[bool, Form()] = False,
    prefer_exit: Annotated[bool, Form()] = False,
    experience: Annotated[int, Form()] = -1,
    entrance_coords: Annotated[Optional[str], Form()] = None,
    exit_coords: Annotated[Optional[str], Form()] = None,
    device_pixel: Annotated[Optional[str], Form()] = None
):
    # Check for empty file
    if not image.filename:
        raise HTTPException(status_code=400, detail="No image file was provided.")
    
    file_path = None
    best_spot = None
    image_response = None

    try:
        # Generate unique filename
        file_extension = os.path.splitext(image.filename)[1]
        prefix_name = uuid.uuid4()
        unique_filename = f"{prefix_name}{file_extension}"
        file_path = os.path.join(UPLOAD_DIRECTORY, unique_filename)

        print(f"Saving upload as {unique_filename}...")

        # Save uploaded file to disk
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)

        # Determine experience level
        experience_level = None
        if experience == 0:
            experience_level = ExperienceLevel.BEGINNER
        elif experience == 1:
            experience_level = ExperienceLevel.INTERMEDIATE
        elif experience >= 2:
            experience_level = ExperienceLevel.EXPERT

        # Parse JSON inputs
        entrance_tuple = tuple(json.loads(entrance_coords))
        exit_tuple = tuple(json.loads(exit_coords))
        pixel_tuple = tuple(json.loads(device_pixel))

        # Run detector
        detector = ParkingSpotDetector(
            model_path="static/model.pt",
            entrance_coords=entrance_tuple,
            exit_coords=exit_tuple,
            result=file_path,
            filename=prefix_name,
            device_pixel=pixel_tuple
        )

        best_spot = detector.start(
            entrance=prefer_entrance,
            exit=prefer_exit,
            experience=experience_level,
            file_path=file_path
        )

    except Exception as e:
        print(f"Upload image error: {e}")
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {e}")
    
    finally:
        # Close file properly
        if hasattr(image, "file") and image.file:
            image.file.close()

        # Prepare response and cleanup
        if file_path:
            image_response = FileResponse(f"images/{prefix_name}_output.png")
            image_response.headers["best_spot"] = str(best_spot)
            background_tasks.add_task(delete_uploaded_file, file_path)
            background_tasks.add_task(delete_uploaded_file, f"images/{prefix_name}_output.png")

    return image_response

def coordinates_to_percentage(coords ,  device_pixel):
    total_height = device_pixel[1]
    total_width = device_pixel[0]

    height_coords = coords[1]
    width_coords = coords[0]

    return [(height_coords/total_height) * 100,( width_coords/total_width ) * 100 ]

def percentage_to_coordinates(percentage, device_pixel):
    height = percentage[1]
    width = percentage[0]

    total_height = device_pixel[1]
    total_width = device_pixel[0]

    return [(height * total_height)/100,(width * total_width)/100]
    