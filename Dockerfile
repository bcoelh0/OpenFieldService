FROM node:22-bookworm-slim
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@9.15.9 --activate && mkdir -p /data && chown node:node /app /data
COPY --chown=node:node . .
USER node
RUN pnpm install --frozen-lockfile && pnpm run build
ENV WRANGLER_SEND_METRICS=false
EXPOSE 8787
CMD ["sh", "-c", "node scripts/setup-db.mjs /data && exec ./node_modules/.bin/wrangler dev --local --ip 0.0.0.0 --port 8787 --persist-to /data"]
