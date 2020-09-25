FROM golang:1.12.0-alpine3.9
RUN mkdir /app
COPY golang-webserver "/app/"
RUN chmod a+x /app/golang-webserver
WORKDIR /app
ENTRYPOINT ["/app/golang-webserver"]