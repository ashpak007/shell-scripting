#!/bin/bash

# Function to clone the Django app code
code_clone() {
    echo "Cloning the Django app..."
    if [ -d "django-notes-app" ]; then
        echo "The code directory already exists. Skipping clone."
    else
        git clone https://github.com/LondheShubham153/django-notes-app.git || {
            echo "Failed to clone the code."
            return 1
        }
    fi
}

# Function to install required dependencies
install_requirements() {
    echo "Installing dependencies..."
    sudo yum update -y && sudo yum install -y docker nginx || {
        echo "Failed to install dependencies."
        return 1
    }
}

# Function to perform required restarts and setup
required_restarts() {
    echo "Performing required restarts and network setup..."
    sudo systemctl enable --now docker
    sudo systemctl enable --now nginx

    # Create Docker Network if it doesn't exist
    docker network create notes-net 2>/dev/null || true

    sudo usermod -aG docker "$USER"
    # Ensure current user can access docker socket
    sudo chown "$USER" /var/run/docker.sock
}

# Function to deploy the Django app
deploy() {
    echo "Building and deploying the Django app..."
    
    # 1. Handle Database (Start/Restart)
    echo "Starting Database container..."
    docker rm -f db_cont 2>/dev/null
    docker run -d \
      --name db_cont \
      --network notes-net \
      -e MYSQL_ROOT_PASSWORD=admin123 \
      -e MYSQL_DATABASE=notes_db \
      mysql:5.7

    echo "Waiting for database to initialize (15s)..."
    sleep 15

    # 2. Build and Run App
    cd django-notes-app || return 1
    docker build -t notes-app .
    
    echo "Cleaning old app container..."
    docker rm -f django-app 2>/dev/null

    echo "Launching Django container..."
    docker run -d \
      --name django-app \
      --network notes-net \
      -p 8000:8000 \
      -e DB_NAME=notes_db \
      -e DB_USER=root \
      -e DB_PASSWORD=admin123 \
      -e DB_HOST=db_cont \
      -e DB_PORT=3306 \
      notes-app \
      python3 manage.py runserver 0.0.0.0:8000

    # 3. Run Migrations
    echo "Running database migrations..."
    sleep 5
    docker exec django-app python3 manage.py migrate || {
        echo "Migrations failed."
        return 1
    }
}

# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

code_clone
install_requirements
required_restarts

if ! deploy; then
    echo "Deployment failed."
    exit 1
fi

echo "********** DEPLOYMENT SUCCESSFUL *********"
echo "Access your app at http://$(curl -s ifconfig.me):8000"
