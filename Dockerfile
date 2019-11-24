FROM gcr.io/kaniko-project/executor:latest AS build

FROM alpine:3.10.3

COPY --from=build /kaniko /kaniko
COPY ci /ci

RUN apk add ca-certificates
