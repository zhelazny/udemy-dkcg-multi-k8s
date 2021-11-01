
# Build all images, tag each one
docker build -t zhelazny/multi-frontend:latest -t zhelazny/multi-frontend:$GIT_SHA -f ./frontend/Dockerfile ./frontend
docker build -t zhelazny/multi-api:latest -t zhelazny/multi-api:$GIT_SHA -f ./api/Dockerfile ./api
docker build -t zhelazny/multi-worker:latest -t zhelazny/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

# push each to docker hub
docker push zhelazny/multi-frontend:latest
docker push zhelazny/multi-api:latest
docker push zhelazny/multi-worker:latest

docker push zhelazny/multi-frontend:$GIT_SHA
docker push zhelazny/multi-api:$GIT_SHA
docker push zhelazny/multi-worker:$GIT_SHA

# apply k8s config
kubectl apply -f k8s

# imperatively set latest images on each deployment
kubectl set image deployments/frontend-deployment frontend=zhelazny/multi-frontend:$GIT_SHA
kubectl set image deployments/api-deployment api=zhelazny/multi-api:$GIT_SHA
kubectl set image deployments/worker-deployment worker=zhelazny/multi-worker:$GIT_SHA