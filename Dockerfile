FROM node:22-bookworm-slim
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@9.15.9 --activate
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build
ENV WRANGLER_SEND_METRICS=false
EXPOSE 8787
CMD ["sh", "-c", "node scripts/setup-db.mjs /data && exec ./node_modules/.bin/wrangler dev --local --ip 0.0.0.0 --port 8787 --persist-to /data"]
