#!/usr/bin/env

echo "Prerequisites initializing ..."
kubectl apply -f mongo-secret.yml
kubectl apply -f mongo-configmap.yml

echo "Backend mongo container creating ..."
kubectl apply -f mongo.yml

echo "Frontend express container creating ..."
kubectl apply -f mongo-express.yml

echo "deployment completed open express on http://SERVER:30000"