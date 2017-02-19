FROM node:6.9.5

MAINTAINER Alexis Bellés Marzà

EXPOSE 3000

RUN npm install pm2 -g

RUN mkdir -p /usr/src/app

RUN chown -R node:node /usr/src/app

USER node

WORKDIR /usr/src/app

COPY package.json /usr/src/app

RUN npm install --production

COPY . /usr/src/app

CMD [ "pm2-docker", "process.yml"]
