FROM node:lts-alpine as builder

ARG version=2.4.2

RUN apk add --no-cache git python make g++

WORKDIR /app

RUN git clone https://github.com/wasc-io/zone-mta-template ./

RUN yarn
RUN yarn add @wasc/zonemta-wildduck


FROM node:lts-alpine as app

ENV NODE_ENV production

RUN apk add --no-cache tini

WORKDIR /app
COPY --from=builder /app /app

ENTRYPOINT ["/sbin/tini", "--", "node", "index.js"]
CMD ["--config=config/zonemta.toml"]