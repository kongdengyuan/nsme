FROM ubuntu:16.04 AS builder-file

ARG https_proxy=""

RUN mkdir /build && apt-get update && apt-get install  build-essential curl -y

RUN  curl -sL https://deb.nodesource.com/setup_10.x | bash -  && apt-get install -y nodejs

COPY ./x4-s4one /build/x4-s4one

WORKDIR /build/x4-s4one

RUN  npm install && npm run build

FROM node:10.16.3-alpine

RUN mkdir -p /app /var/log/x4-s4one

COPY  --from=builder-file /build/x4-s4one /app/x4-s4one

WORKDIR  /app/x4-s4one

CMD ["sh","start-x4-s4one.sh"]

