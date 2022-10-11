FROM nginx:stable-alpine AS base
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
RUN cat /etc/nginx/conf.d/default.conf | \
      sed 's/\s*listen\s*\[::\]:80.*/    #listen [::]:80;/' | \
      sed 's/\s*server_name\s*localhost.*/    #server_name localhost;/' | \
      sed 's/\s*location\s*\/\s*{.*/    location \/ {\n        try_files $uri $uri\/ \/index.html;/' > \
    /etc/nginx/conf.d/default.back.conf && \
    mv /etc/nginx/conf.d/default.back.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

FROM node:lts-alpine AS builder
WORKDIR /src
COPY package.json ./
COPY .yarnrc ./
RUN yarn install --production
COPY . ./
RUN yarn add -D webpack
RUN yarn build:dev

FROM base AS final
WORKDIR /usr/share/nginx/html
COPY --from=builder /src/dist .