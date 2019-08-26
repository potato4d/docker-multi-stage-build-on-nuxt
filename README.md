# Docker multi stage build on Nuxt.js project

This is a sample for Nuxt Meetup (in Japan) of 2019/08/26.

## Structure

Using Docker's multi stage build (available from 17.05), the development environment, build environment, and production environment can be shared with a single Dockerfile.

```Dockerfile
# For development

FROM node:10.16.1-alpine as dev-env
WORKDIR /app
COPY . /app
RUN apk update
RUN yarn
EXPOSE 3000
CMD ["yarn", "dev"]

# For build

FROM node:10.16.1-alpine as build-env
WORKDIR /app
COPY . /app
RUN apk update
RUN yarn
RUN yarn build

# For production
FROM node:10.16.1-alpine

WORKDIR /app
COPY . /app

# Copy from another build
COPY --from=build-env /app/.nuxt /app/.nuxt
RUN yarn
EXPOSE 3000
CMD ["yarn", "start"]
```