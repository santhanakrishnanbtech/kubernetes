#!/usr/bin/env bash

echo "Destroying frontend application ..."
kubectl delete -f mongo-express.yml

echo "Destroying backend application ..."
kubectl delete -f mongo.yml

echo "Destroying prerequisites ..."
kubectl delete -f mongo-configmap.yml
kubectl delete -f mongo-secret.yml