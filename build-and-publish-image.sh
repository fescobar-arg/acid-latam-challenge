#!/bin/bash

# Build docker image
docker build -t $1/challenge-app:latest app/.
# Login to ACR
docker login $1 -u $2 -p $3
# Push Docker Image to ACR
docker push $1/challenge-app:latest
