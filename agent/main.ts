import { Application, log } from "./deps.ts";
import { router } from "./router.ts";
import "https://deno.land/std@0.182.0/dotenv/load.ts"; // auto loading .env into environment variables

await log.setup({
  handlers: {
      console: new log.handlers.ConsoleHandler("DEBUG", {
        formatter: function(r: log.LogRecord) {
          return ["[" + r.levelName + "]", r.datetime.toISOString(), r.msg].join(" ");
        }
      })
  },
  loggers: {
      default: {
          level: "DEBUG",
          handlers: ["console"],
      }
  }
});

const app = new Application({ logErrors: false });

app.addEventListener("listen", ({ hostname, port, secure }) => {
  log.info(
    `Listening on: ${secure ? "https://" : "http://"}${hostname ?? "localhost"}:${port}`
  );
});

app.addEventListener("error", (evt) => {
  log.error(`${evt.error.name}: ${evt.error.message}`);
});

app.use(router.routes());
app.use(router.allowedMethods());

const port = Number(Deno.env.get("API_PORT")) || 8089;
await app.listen({ port: port });