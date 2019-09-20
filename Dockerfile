FROM golang:1.12.7-alpine3.10 AS builder

RUN \
    apk add --no-cache \
        ca-certificates \
        gcc \
        git

WORKDIR /go/src/app

COPY *.go ./

RUN go get -d -v ./...

RUN CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    go build -a -ldflags '-extldflags "-static"' \
    -o cloud-platform-http-error-handler .


FROM scratch

COPY --from=builder /go/src/app/cloud-platform-http-error-handler /

EXPOSE 8080/tcp

USER 65534

CMD ["/cloud-platform-http-error-handler"]