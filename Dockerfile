FROM nginx:1.21.6

RUN rm /etc/nginx/conf.d/default.conf

COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./app /usr/share/nginx/html

ENV PORT=$port

CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'

