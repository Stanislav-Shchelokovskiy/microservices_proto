# Release an update
git tag -a go/order/v1.0.0 -m "go/order/v1.0.0"
git tag -a go/payment/v1.0.0 -m "go/payment/v1.0.0"
git tag -a go/shipping/v1.0.0 -m "go/shipping/v1.0.0"
git push --tags

# Download go packages
go get -u github.com/Stanislav-Shchelokovskiy/microservices_proto/go/order@v1.0.0