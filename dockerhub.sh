#!/bin/bash
set -e

version=1.0.0
docker build . -f Dockerfile -t zjb0807/neb:"$version"
#docker build . -f Dockerfile --no-cache -t zjb0807/neb:"$version"

docker tag zjb0807/neb:"$version" zjb0807/neb:latest

docker login
docker push zjb0807/neb:"$version"
docker push zjb0807/neb:latest
