# Use the official Python image as the base image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the poetry files to the container
COPY poetry.lock pyproject.toml /app/

# Install poetry and project dependencies
RUN pip install poetry==1.7.1 && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Copy the source code to the container
COPY src /app/src

# Expose the port that FastAPI will run on
EXPOSE 8000

# Start the FastAPI application
CMD ["uvicorn", "src.helloworldapi.main:app", "--host", "0.0.0.0", "--port", "8000"]
