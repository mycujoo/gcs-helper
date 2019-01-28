#FROM linuxkit/ca-certificates:v0.6 AS ca-certificates

FROM    golang:1.11.5-alpine AS build_base
RUN     apk add gcc g++ git libc-dev --update

ENV GO111MODULE=on

WORKDIR /code
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /usr/bin/gcs-helper


FROM alpine:3.8
RUN apk add --no-cache --update ca-certificates
COPY --from=build_base /usr/bin/gcs-helper /usr/bin/gcs-helper
ENTRYPOINT ["/usr/bin/gcs-helper"]
