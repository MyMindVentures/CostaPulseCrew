FROM alpine:3.22

RUN apk add --no-cache git ca-certificates coreutils

WORKDIR /app
COPY railway-importer/import.sh /app/import.sh
RUN chmod +x /app/import.sh

CMD ["/app/import.sh"]
