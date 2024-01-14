FROM denoland/deno:debian-1.32.3 AS base
WORKDIR /app
RUN chown -R deno:deno /deno-dir && chmod -R 770 /deno-dir
RUN chown -R deno:deno /app && chmod -R 770 /app

FROM base AS dev
USER deno
COPY --chown=deno:deno . /app
RUN deno cache main.ts
CMD ["run", "--allow-net", "--allow-read", "--allow-env", "main.ts"]
