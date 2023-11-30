# Install the base requirements for the app.
# This stage is to support development.
#FROM --platform=$BUILDPLATFORM python:alpine AS base
FROM python:alpine AS base
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

#FROM --platform=$BUILDPLATFORM node:18-alpine AS app-base
FROM node:18-alpine AS app-base
WORKDIR /app
COPY app/package.json app/yarn.lock ./
COPY app/spec ./spec
COPY app/src ./src

# Run tests to validate app
FROM app-base AS test
RUN yarn install 
##B RUN yarn install --ignore-scripts does not execute any scripts defined in the project package.json and its dependencies.
RUN yarn test

# Clear out the node_modules and create the zip
FROM app-base AS app-zip-creator
COPY --from=test /app/package.json /app/yarn.lock ./
COPY app/spec ./spec
COPY app/src ./src
RUN apk add zip && \
    zip -r /app.zip /app

# Dev-ready container - actual files will be mounted in
#FROM --platform=$BUILDPLATFORM base AS dev
FROM base AS dev
CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]

# Do the actual build of the mkdocs site
#FROM --platform=$BUILDPLATFORM base AS build
FROM base AS build
COPY . .
RUN mkdocs build

# Extract the static content from the build
# and use a nginx image to serve the content
#FROM --platform=$TARGETPLATFORM nginx:alpine
FROM nginx:alpine
USER ${username:-gentle}
ARG username
USER $username
COPY --from=app-zip-creator /app.zip /usr/share/nginx/html/assets/app.zip
COPY --from=build /app/site /usr/share/nginx/html


