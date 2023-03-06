FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .
COPY .env .

CMD ["node", "--trace-warnings", "index.js"]
