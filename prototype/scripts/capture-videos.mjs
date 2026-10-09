import { chromium } from 'playwright';
import { mkdirSync, renameSync } from 'node:fs';
import { join } from 'node:path';

const out = '/Users/ruka/psgy/prototype/docs/ux-v2/evidence';
mkdirSync(out, { recursive: true });
const BASE = 'http://localhost:5175/?desk=1';

async function act(page, fn) {
  await page.evaluate(fn);
  await page.waitForTimeout(700);
}

async function record(browser, name, steps) {
  const ctx = await browser.newContext({
    viewport: { width: 1600, height: 980 },
    recordVideo: { dir: out, size: { width: 1600, height: 980 } },
  });
  const page = await ctx.newPage();
  await page.goto(BASE, { waitUntil: 'networkidle' });
  await page.evaluate(() => localStorage.removeItem('psgy-proto-v2'));
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(800);
  await steps(page);
  const vid = page.video();
  await ctx.close();
  const src = await vid.path();
  renameSync(src, join(out, `${name}.webm`));
  console.log('wrote', name);
}

async function main() {
  const browser = await chromium.launch({ headless: true, channel: 'chrome' });

  await record(browser, 'Video_C', async (page) => {
    await act(page, () => {
      const s = window.__psgy.getState();
      s.openPt('pt_01');
    });
    await act(page, () => window.__psgy.getState().pop('user'));
    await act(page, () => window.__psgy.getState().openPt('pt_01'));
    await act(page, () => window.__psgy.getState().setTab('pt', 'PC1'));
    await act(page, () => window.__psgy.getState().jump('pt', { id: 'PC3' }));
    await act(page, () => window.__psgy.getState().sendGreeting('Chào Minh, mình kèm giảm mỡ 3 buổi/tuần được không?'));
    await act(page, () => window.__psgy.getState().setTab('user', 'UC1'));
    await act(page, () => {
      const g = window.__psgy.getState().greetings[0];
      if (g) window.__psgy.getState().answerGreeting(g.id, true);
    });
    await act(page, () => {
      const p = window.__psgy.getState().pts.find((x) => x.id === 'pt_01').packages[2];
      window.__psgy.getState().sendCard('th_pt_01', 'pt', { type: 'package', packageId: p.id, label: `${p.name} · ${p.priceVnd}` }, 'Xem gói');
    });
    await act(page, () => {
      const p = window.__psgy.getState().pts.find((x) => x.id === 'pt_01').packages[2];
      window.__psgy.getState().startBooking('pt_01', p.id);
    });
    await act(page, () => window.__psgy.getState().jump('user', { id: 'UB4' }));
    await act(page, () => {
      window.__psgy.getState().payBooking();
    });
    await page.waitForTimeout(1200);
    await act(page, () => {
      const ct = window.__psgy.getState().contracts.find((c) => c.status === 'pending');
      if (ct) window.__psgy.getState().confirmContract(ct.id);
    });
    await page.waitForTimeout(800);
  });

  await record(browser, 'Video_D', async (page) => {
    await act(page, () => window.__psgy.getState().clockJump('remain60'));
    await act(page, () => window.__psgy.getState().clockJump('late8'));
    await act(page, () => window.__psgy.getState().jump('pt', { id: 'PSD1', params: { sessionId: 'ss_today' } }));
    await act(page, () => window.__psgy.getState().arrive('ss_today'));
    await act(page, () => window.__psgy.getState().startByPhoto('ss_today'));
    await act(page, () => window.__psgy.getState().jump('pt', { id: 'PSE1', params: { sessionId: 'ss_today' } }));
    await act(page, () =>
      window.__psgy.getState().submitSummary('ss_today', {
        actualMin: 58,
        muscles: ['Ngực'],
        progress: 'up',
        nextNote: 'Tăng tạ nhẹ',
      }),
    );
    await act(page, () => window.__psgy.getState().jump('user', { id: 'USS1', params: { sessionId: 'ss_today' } }));
    await act(page, () => window.__psgy.getState().confirmComplete('ss_today'));
    await act(page, () => window.__psgy.getState().addReview('ss_today', 'love', ['Rất tận tâm'], ''));
    await act(page, () => window.__psgy.getState().setTab('pt', 'PI1'));
    await act(page, () => window.__psgy.getState().clockJump('plus3d'));
    await act(page, () => window.__psgy.getState().jump('pt', { id: 'PI3' }));
    await act(page, () => {
      const mc = window.__psgy.getState();
      const avail = mc.ledger.filter((l) => l.status === 'withdrawable').reduce((a, l) => a + l.net, 0);
      mc.withdraw(avail);
    });
    await page.waitForTimeout(800);
  });

  await record(browser, 'Video_E', async (page) => {
    await act(page, () => window.__psgy.getState().jump('user', { id: 'URS1', params: { sessionId: 'ss_today' } }));
    await act(page, () => window.__psgy.getState().proposeReschedule('ss_today', Date.now() + 86400000, 'user'));
    await act(page, () => window.__psgy.getState().setTab('pt', 'PW1'));
    await act(page, () => window.__psgy.getState().answerReschedule('ss_today', true));
    await act(page, () => window.__psgy.getState().cancelSession('ss_today', 'pt', 'PT bận đột xuất'));
    await act(page, () => window.__psgy.getState().jump('user', { id: 'UW1' }));
    await page.waitForTimeout(600);
    await act(page, () => window.__psgy.getState().reset());
    await act(page, () => window.__psgy.getState().clockJump('plus15after'));
    await act(page, () => window.__psgy.getState().reportNoShowPt('ss_today'));
    await act(page, () => {
      const s = window.__psgy.getState();
      const p = s.pts.find((x) => x.id === 'pt_01').packages[0];
      s.startBooking('pt_01', p.id);
      s.payBooking();
    });
    await page.waitForTimeout(900);
    await act(page, () => window.__psgy.getState().clockJump('plus24h'));
    await act(page, () => window.__psgy.getState().jump('user', { id: 'UW1' }));
    await page.waitForTimeout(800);
  });

  await browser.close();
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
