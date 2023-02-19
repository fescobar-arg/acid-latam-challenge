#!/bin/bash


# Login to the ACR using the az CLI
#az acr login --name $1



#######

docker build -t $1/challenge-app:latest app/.
# Login to ACR
docker login $1 -u $2 -p $3
# Push Docker Image to ACR
docker push $1/challenge-app:latest

: << 'COMMENT'
# Build Docker Image
sudo docker build -t latamchallengefastapiappacr.azurecr.io/challenge-app:latest app/.
# Login to ACR
sudo docker login latamchallengefastapiappacr.azurecr.io -u latamchallengefastapiappACR -p SXzwt+xyrg7vnEr1sbPxh6VaPvN++xzOuJ3ff/HYxl+ACRDjlA7h
# Push Docker Image to ACR
sudo docker push latamchallengefastapiappacr.azurecr.io/challenge-app:latest

# Build Docker Image

# Get the ACR name from Terraform output
acr_name=$(terraform output acr_name)

# Build the Docker image
docker build -t $docker_image_name .

# Tag the Docker image
docker tag $docker_image_name $acr_name.azurecr.io/$docker_image_name:$docker_image_tag

# Login to Azure Container Registry
az acr login --name $acr_name

# Push the Docker image to Azure Container Registry
docker push $acr_name.azurecr.io/$docker_image_name:$docker_image_tag

# Clean up the Docker image
docker rmi $docker_image_name
docker rmi $acr_name.azurecr.io/$docker_image_name:$docker_image_tag
COMMENT
