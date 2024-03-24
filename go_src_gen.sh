#!/bin/bash
SERVICE_NAME=$1
RELEASE_VERSION=$2

echo service name ${SERVICE_NAME}
echo release version ${RELEASE_VERSION}

echo "Install deps"
sudo apt install -y protobuf-compiler golang-goprotobuf-dev
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

echo "Ensure go dir"
mkdir -p go/${SERVICE_NAME}

echo "Compile protos"
protoc --go_out=./go --go_opt=paths=source_relative \
    --go-grpc_out=./go --go-grpc_opt=paths=source_relative \
    ./${SERVICE_NAME}/*.proto

echo "Init mod"
cd go/${SERVICE_NAME}
go mod init \ 
    git@github.com:Stanislav-Shchelokovskiy/microservices_proto/go/${SERVICE_NAME} ||true
go mod tidy
cd ../..

echo "Git push"
git config --global user.email stanislav.shchelokovskiy@gmail.com
git config --global user.name Stanislav Shchelokovskiy
git add . && git commit -am "proto update" ||true
git tag -fa go/${SERVICE_NAME}/${RELEASE_VERSION} \
    -m go/${SERVICE_NAME}/${RELEASE_VERSION}
git push origin refs/tags/go/${SERVICE_NAME}/${RELEASE_VERSION}
