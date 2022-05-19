FROM nginx:alpine

COPY ./app /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
