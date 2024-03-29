#Builder Image
FROM registry.access.redhat.com/ubi9-minimal AS builder
#Install Golang packages
RUN microdnf upgrade && \
    microdnf install golang && \
    microdnf clean all
#Copy files for build
COPY go.mod /go/src/hello-world/
COPY main.go /go/src/hello-world/
#Set the working directory
WORKDIR /go/src/hello-world
#Download dependencies
RUN go get -d -v ./...
#Install the package
RUN go build -v ./...
#Runtime image
FROM registry.access.redhat.com/ubi9/ubi-micro:latest
COPY --from=builder /go/src/hello-world/hello-world /
EXPOSE 8080
CMD ["/hello-world"]

