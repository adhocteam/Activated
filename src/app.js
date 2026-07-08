import { createServer } from "node:http";
import { createOpportunity, listOpportunities } from "./services/opportunityService.js";

const PORT = Number(process.env.PORT ?? "3000");

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, { "Content-Type": "application/json; charset=utf-8" });
  response.end(JSON.stringify(payload));
}

function parseJsonBody(request) {
  return new Promise((resolve, reject) => {
    const chunks = [];

    request.on("data", (chunk) => chunks.push(chunk));
    request.on("end", () => {
      try {
        const raw = Buffer.concat(chunks).toString("utf8");
        const parsed = raw ? JSON.parse(raw) : {};
        resolve(parsed);
      } catch (error) {
        reject(error);
      }
    });
    request.on("error", reject);
  });
}

const server = createServer(async (request, response) => {
  const { method, url } = request;

  if (method === "GET" && url === "/health") {
    return sendJson(response, 200, { status: "ok", service: "activated-mock" });
  }

  if (method === "GET" && url === "/api/opportunities") {
    return sendJson(response, 200, { data: listOpportunities() });
  }

  if (method === "POST" && url === "/api/opportunities") {
    try {
      const payload = await parseJsonBody(request);
      const result = createOpportunity(payload);

      if (!result.ok) {
        return sendJson(response, 400, { error: result.error });
      }

      return sendJson(response, 201, { data: result.value });
    } catch {
      return sendJson(response, 400, { error: "Invalid JSON payload" });
    }
  }

  return sendJson(response, 404, { error: "Route not found" });
});

server.listen(PORT, () => {
  console.log(`Activated mock service listening on port ${PORT}`);
});
