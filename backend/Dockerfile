FROM python:3.9

# Set working directory
WORKDIR /app

# Copy backend code
COPY . .

# Copy environment file (optional, make sure .env exists locally)
COPY .env .env

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port (matches var.app_port)
EXPOSE 80

# Start the app
CMD ["python", "run.py"]

