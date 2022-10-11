FROM nginx:stable-alpine AS base
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
EXPOSE 80

FROM node:lts-alpine AS builder
WORKDIR /src
COPY package.json ./
RUN yarn install --production
COPY . ./
RUN yarn add -D -W lerna
RUN yarn add -D -W @storybook/cli@6.3.4
RUN yarn build

FROM base AS final
WORKDIR /usr/share/nginx/html
COPY --from=builder /src/docs/dist .