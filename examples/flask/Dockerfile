# Build an image starting with the Python 3.4 image
FROM python:3.4alpine
# Add the current directory "." into the path "/code" in the image
Add . /code
# Set the working directory to "/code"
WORKDIR /code
# Install the Python dependecies
RUN pip install -r requirements.txt
# Set the default command for the container
CMD ["python", "app.py"]
