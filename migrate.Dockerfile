FROM node:15.5.0-alpine3.10

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm install -g truffle@5.1.59

COPY . .

RUN truffle compile

CMD [ "truffle", "migrate", "--network", "ropsten" ]