FROM golang:1.17-alpine AS build
RUN apk add git upx

WORKDIR /go/src/app
COPY . /go/src/app

RUN go get -d -v ./...
RUN env CGO_ENABLED=0 go build -ldflags '-w -s' -o /go/bin/app ./cmd/carwings
RUN upx --ultra-brute /go/bin/app

FROM gcr.io/distroless/static
COPY --from=build /go/bin/app /
ENTRYPOINT [ "/app"]

