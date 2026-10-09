import { chromium } from 'playwright';
import { mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = '/Users/ruka/psgy/prototype';
const out = join(root, 'docs/ux-v2/evidence');
mkdirSync(out, { recursive: true });

const BASE = process.env.PROTO_URL ?? 'http://localhost:5175/?desk=1';

async function store(page) {
  return page.evaluate(() => window.__psgy);
}

async function jump(page, role, id, params) {
  await page.evaluate(
    ({ role, id, params }) => {
      window.__psgy.getState().jump(role, { id, params });
    },
    { role, id, params },
  );
  await page.waitForTimeout(350);
}

async function shot(page, name) {
  await page.screenshot({ path: join(out, `${name}.png`), fullPage: true });
}

async function main() {
  const browser = await chromium.launch({ headless: true, channel: 'chrome' });
  const page = await browser.newPage({ viewport: { width: 1600, height: 980 } });
  await page.goto(BASE, { waitUntil: 'networkidle' });
  await page.waitForTimeout(800);
  await page.evaluate(() => {
    localStorage.removeItem('psgy-proto-v2');
  });
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(600);
  const hasStore = await page.evaluate(() => Boolean(window.__psgy));
  if (!hasStore) {
    throw new Error('window.__psgy missing — App did not mount');
  }
  await page.evaluate(() => window.__psgy.getState().commit({ muteTimedPopups: true }));

  const screens = [
    ['PO1', 'pt', 'PO1'],
    ['PW1', 'pt', 'PW1'],
    ['PSD1', 'pt', 'PSD1'],
    ['PSE1', 'pt', 'PSE1'],
    ['PC1', 'pt', 'PC1'],
    ['PC3', 'pt', 'PC3'],
    ['PI1', 'pt', 'PI1'],
    ['PI3', 'pt', 'PI3'],
    ['PM1', 'pt', 'PM1'],
    ['PM4', 'pt', 'PM4'],
    ['PM5', 'pt', 'PM5'],
    ['PM7', 'pt', 'PM7'],
    ['PM8', 'pt', 'PM8'],
    ['PM9', 'pt', 'PM9'],
    ['PN1', 'pt', 'PN1'],
    ['PL2', 'pt', 'PL2'],
    ['USE1', 'user', 'USE1'],
    ['USE2', 'user', 'USE2'],
    ['UW1', 'user', 'UW1'],
  ];
  for (const [file, role, id] of screens) {
    if (id === 'PO1') {
      await jump(page, 'pt', 'PO1');
      await shot(page, 'PO1');
      await page.evaluate(() => {
        const sc = document.querySelector('[data-phone="pt"] .overflow-y-auto');
        if (sc) sc.scrollTop = sc.scrollHeight;
      });
      await page.waitForTimeout(200);
      await shot(page, 'PO1_month');
      continue;
    }
    if (id === 'PW1') {
      await jump(page, 'pt', 'PW1');
      await shot(page, 'PW1_today');
      await page.evaluate(() => {
        const btns = [...document.querySelectorAll('button')];
        btns.find((b) => b.textContent?.includes('Sắp tới'))?.click();
      });
      await page.waitForTimeout(200);
      await shot(page, 'PW1_soon');
      await page.evaluate(() => {
        const btns = [...document.querySelectorAll('button')];
        btns.find((b) => b.textContent?.includes('Cần xử lý'))?.click();
      });
      await page.waitForTimeout(200);
      await shot(page, 'PW1_todo');
      continue;
    }
    if (id === 'PC1') {
      await jump(page, 'pt', 'PC1');
      await shot(page, 'PC1_msg');
      await page.evaluate(() => {
        const btns = [...document.querySelectorAll('button')];
        btns.find((b) => b.textContent?.includes('Chờ chấp nhận'))?.click();
      });
      await page.waitForTimeout(200);
      await shot(page, 'PC1_wait');
      await page.evaluate(() => {
        const btns = [...document.querySelectorAll('button')];
        btns.find((b) => b.textContent?.includes('Khách quan tâm'))?.click();
      });
      await page.waitForTimeout(200);
      await shot(page, 'PC1_interest');
      continue;
    }
    if (id === 'PI1') {
      await jump(page, 'pt', 'PI1');
      await shot(page, 'PI1_over');
      await page.evaluate(() => {
        const btns = [...document.querySelectorAll('button')];
        btns.find((b) => b.textContent?.trim() === 'Giao dịch')?.click();
      });
      await page.waitForTimeout(200);
      await shot(page, 'PI1_tx');
      await page.evaluate(() => {
        const btns = [...document.querySelectorAll('button')];
        btns.find((b) => b.textContent?.trim() === 'Rút tiền')?.click();
      });
      await page.waitForTimeout(200);
      await shot(page, 'PI1_wd');
      continue;
    }
    if (id === 'USE1') {
      await page.evaluate(() => {
        const s = window.__psgy.getState();
        s.confirmComplete('ss_today');
        s.jump('user', { id: 'USE1', params: { sessionId: 'ss_today' } });
      });
      await page.waitForTimeout(400);
      await shot(page, file);
      continue;
    }
    if (id === 'USE2') {
      await page.evaluate(() => window.__psgy.getState().forceLastSession());
      await page.waitForTimeout(400);
      await shot(page, file);
      continue;
    }
    if (id === 'PL2') {
      await page.evaluate(() => window.__psgy.getState().commit({ ptPendingApproval: true }));
      await jump(page, 'pt', 'PL2');
      await shot(page, file);
      await page.evaluate(() => window.__psgy.getState().commit({ ptPendingApproval: false }));
      await jump(page, 'pt', 'PO1');
      continue;
    }
    await jump(page, role, id);
    await shot(page, file);
  }

  await page.evaluate(() => {
    const btns = [...document.querySelectorAll('button')];
    btns.find((b) => b.textContent?.includes('Config'))?.click();
  });
  await page.waitForTimeout(250);
  await shot(page, 'money_check');

  await browser.close();
  console.log('screenshots ok', out);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
