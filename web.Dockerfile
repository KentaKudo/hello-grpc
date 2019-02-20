ARG GO_VERSION=1.11

FROM golang:${GO_VERSION}-alpine AS builder

RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group

RUN apk add --no-cache git

WORKDIR /src

COPY ./go.mod ./go.sum ./
RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -o /app \
    github.com/KentaKudo/hello-grpc/web

FROM scratch AS final

COPY --from=builder /user/group /user/passwd /etc/

COPY --from=builder /app /app

COPY ./dist/* ./index.html /

EXPOSE 8081

USER nobody:nobody

ENTRYPOINT [ "/app" ]
