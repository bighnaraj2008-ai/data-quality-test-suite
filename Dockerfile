FROM alpine:3.19

RUN apk add --no-cache bash sqlite python3 postgresql-client

WORKDIR /workspace
COPY . /workspace

ENTRYPOINT ["bash", "scripts/run_tests.sh"]
CMD ["--db", "target/quality.db", "--seed"]
