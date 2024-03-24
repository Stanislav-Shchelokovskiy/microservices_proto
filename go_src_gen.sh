#!/bin/bash

RELEASE_VERSION=$1
USER_NAME=$2
EMAIL=$3

git config user.name "$USER_NAME"
git config user.email "$EMAIL"
git pull
git checkout main

sudo apt-get install -y protobuf-compiler golang-goprotobuf-dev
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest


for SERVICE_NAME in order payment shipping;
do
    SERVICE_PATH=go/${SERVICE_NAME}
    mkdir -p ${SERVICE_PATH}

    protoc  --go_out=./go --go_opt=paths=source_relative \
            --go-grpc_out=./go --go-grpc_opt=paths=source_relative \
            ./${SERVICE_NAME}/*.proto

    cd ${SERVICE_PATH}

    go mod init github.com/Stanislav-Shchelokovskiy/microservices_proto/${SERVICE_PATH}
    go mod tidy

    cd ../../

    git add .
    git commit -am "proto update"
    git push
    git tag -fa ${SERVICE_PATH}/${RELEASE_VERSION} -m "${SERVICE_PATH}/${RELEASE_VERSION}" 
    git push origin refs/tags/${SERVICE_PATH}/${RELEASE_VERSION}
done
