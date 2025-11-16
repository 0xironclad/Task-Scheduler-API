# 1. Build Stage
FROM node:20 AS builder

WORKDIR /app

COPY package*.json ./ 

RUN npm i --production=false

COPY . .

RUN npm run build 


# 2. Runtime Stage
FROM node:20-slim AS runtime

WORKDIR /app 

ENV NODE_ENV=production 

COPY package*.json ./

RUN npm i --production

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/index.ts"]
