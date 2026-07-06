#!/bin/bash

ACCOUNT_ID=090794735342
REGION=ap-south-1

# Backend
cd ../../ares-app/backend
docker build -t ares-backend .
docker tag ares-backend:latest ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/ares-backend:latest
docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/ares-backend:latest

# Frontend
cd ../frontend
docker build -t ares-frontend .
docker tag ares-frontend:latest ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/ares-frontend:latest
docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/ares-frontend:latest

echo "Images pushed successfully!"