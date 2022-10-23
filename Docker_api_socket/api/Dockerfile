FROM node:15.8

WORKDIR /api
COPY package*.json ./
RUN npm install
COPY . .

CMD ["npm", "run" ,"dev"]