# Stage 1: Build & Install Dependencies
FROM node:20-alpine AS builder
WORKDIR /usr/src/app
COPY app/package*.json ./
RUN npm install --omit=dev

# Stage 2: Minimal Runtime Image
FROM node:20-alpine AS runner
WORKDIR /usr/src/app
ENV NODE_ENV=production
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY app/server.js .
COPY app/package.json .

EXPOSE 3000
USER node
CMD ["node", "server.js"]
