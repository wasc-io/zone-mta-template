# syntax=docker/dockerfile:1.3

FROM node:lts-alpine as builder
WORKDIR /app

ADD . .


RUN --mount=type=cache,target=/usr/local/share/.cache/yarn/v6 yarn --frozen-lockfile --network-timeout 500000

FROM node:lts-alpine as app

ENV NODE_ENV production

RUN apk add --no-cache tini

WORKDIR /app
COPY --from=builder /app /app

ENTRYPOINT ["/sbin/tini", "--", "node", "index.js"]
CMD ["--config=config/zonemta.toml"]