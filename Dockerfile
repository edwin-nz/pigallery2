#-----------------BUILDER-----------------
FROM node:18-bookworm AS builder

WORKDIR /app

# Install dependencies only
COPY package.json package-lock.json ./

RUN npm config set registry https://registry.npmjs.org/ && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retry-maxtimeout 120000 && \
    npm ci

RUN npm install

# Copy source code and clean previous builds
COPY . .
RUN rm -rf dist && npm run create-release

WORKDIR /app/release
RUN npm install --omit=dev

#-----------------MAIN--------------------
FROM node:18-bookworm-slim AS main

WORKDIR /app

ENV NODE_ENV=production \
    default-Database-dbFolder=/app/data/db \
    default-Media-folder=/app/data/images \
    default-Media-tempFolder=/app/data/tmp \
    default-Extensions-folder=/app/data/config/extensions \
    PI_DOCKER=true

EXPOSE 80

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates ffmpeg wget && \
    rm -rf /var/lib/apt/lists/*

# Copy release from builder
COPY --from=builder /app/release /app

# Create required folders
RUN mkdir -p /app/data/config /app/data/db /app/data/images /app/data/tmp /app/data/test

# Optional diagnostics
RUN node ./src/backend/index --expose-gc --run-diagnostics --config-path=/app/diagnostics-config.json || true

# Healthcheck
HEALTHCHECK --interval=40s --timeout=30s --retries=3 --start-period=60s \
    CMD wget --quiet --tries=1 --no-check-certificate --spider http://127.0.0.1:80/heartbeat || exit 1

# Start the application
ENTRYPOINT ["node", "./src/backend/index", "--expose-gc", "--config-path=/app/data/config/config.json"]
