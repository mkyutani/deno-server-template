import { Router } from "./deps.ts"

const router = new Router();

const ping = function(ctx: any) {
  ctx.response.body = "pong";
}

router.get('/api/v1/ping', ping);

export { router }