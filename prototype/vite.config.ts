import { defineConfig, type Plugin } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import { fileURLToPath, URL } from 'node:url';
import fs from 'node:fs/promises';
import path from 'node:path';
import type { IncomingMessage, ServerResponse } from 'node:http';

function readBody(req: IncomingMessage): Promise<string> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = [];
    req.on('data', (c: Buffer) => chunks.push(c));
    req.on('end', () => resolve(Buffer.concat(chunks).toString('utf8')));
    req.on('error', reject);
  });
}

function json(res: ServerResponse, status: number, body: unknown) {
  res.statusCode = status;
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify(body));
}

function protoDevApi(): Plugin {
  const root = fileURLToPath(new URL('.', import.meta.url));
  return {
    name: 'psgy-proto-dev-api',
    apply: 'serve',
    configureServer(server) {
      server.middlewares.use(async (req, res, next) => {
        const url = req.url?.split('?')[0];
        if (req.method !== 'POST') return next();
        try {
          if (url === '/__proto/save-overrides') {
            const raw = await readBody(req);
            JSON.parse(raw);
            const file = path.join(root, 'src/theme/overrides.json');
            await fs.writeFile(file, `${raw.trim()}\n`, 'utf8');
            return json(res, 200, { ok: true, file: 'src/theme/overrides.json' });
          }
          if (url === '/__proto/export-tokens') {
            const raw = await readBody(req);
            const parsed = JSON.parse(raw) as { markdown?: string };
            if (!parsed.markdown) return json(res, 400, { error: 'missing markdown' });
            const file = path.join(root, 'docs/DESIGN_TOKENS_FINAL.md');
            await fs.writeFile(file, parsed.markdown, 'utf8');
            return json(res, 200, { ok: true, file: 'docs/DESIGN_TOKENS_FINAL.md' });
          }
        } catch (err) {
          return json(res, 500, { error: String(err) });
        }
        return next();
      });
    },
  };
}

export default defineConfig({
  plugins: [react(), tailwindcss(), protoDevApi()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  server: { host: true, port: 5173 },
});
