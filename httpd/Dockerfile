FROM node:latest

RUN npm i http-server -g

RUN useradd --user-group --system httpd

RUN mkdir -p /var/httpd/www
WORKDIR /var/httpd/www
COPY ./index.html .

EXPOSE 8080

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["http-server"]
