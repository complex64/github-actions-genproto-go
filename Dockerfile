FROM golang:1.15 as buildenv
WORKDIR /go/src/app

# Versions pinned using Go modules.
ADD pkg.go go.mod go.sum ./
RUN go install \
    google.golang.org/protobuf/cmd/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc

FROM bufbuild/buf:latest
RUN apk add --no-cache libc6-compat

COPY --from=buildenv \
    /go/bin/protoc-gen-go \
    /go/bin/protoc-gen-go-grpc \
    /bin/

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
