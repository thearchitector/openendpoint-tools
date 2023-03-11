# syntax=docker/dockerfile:1


# == V STAGE
FROM alpine:3.17 as v

ENV VFLAGS "-cc gcc -prod"

WORKDIR /opt/vlang
RUN apk --no-cache add \
        git \
        build-base \
        bash \
        vim && \
    git clone \
        --depth 1 \
        https://github.com/vlang/v . && \
    make && \
    ./v symlink


# == APPLICATION STAGE
FROM v

RUN apk --no-cache add \
        libpq-dev \
        postgresql-client \
        curl \
        jq

WORKDIR /openendpoint-tools
COPY ./ /openendpoint-tools

RUN v -output server .

CMD [ "./server" ]
