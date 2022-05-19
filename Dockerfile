FROM nginx:1.21.6

COPY default.conf /etc/nginx/conf.d/default.conf
COPY ./app /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

