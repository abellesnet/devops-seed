FROM nginx:stable

MAINTAINER Alexis Bellés Marzà

COPY nginx.conf /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/conf.d/default.conf

COPY static-angular/. /usr/share/nginx/html/

RUN mkdir /etc/nginx/sites-available

RUN mkdir /etc/nginx/sites-enabled

COPY nodejs /etc/nginx/sites-available/nodejs

RUN ln -s /etc/nginx/sites-available/nodejs /etc/nginx/sites-enabled/nodejs
