import { chromium } from 'playwright';
import { mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';

const root = '/Users/ruka/psgy/prototype';
const out = join(root, 'docs/ux-v2/style');
mkdirSync(out, { recursive: true });

const BASE = process.env.PROTO_URL ?? 'http://localhost:5175/?desk=1';
const VARIANTS = [
  { id: 'fresh', tag: 'A' },
  { id: 'soft', tag: 'B' },
  { id: 'night', tag: 'C' },
];

const SHOTS = [
  { file: 'discovery', role: 'user', id: 'UD1' },
  { file: 'map', role: 'user', id: 'UM1', wait: 1200 },
  { file: 'pt_profile', role: 'user', id: 'UP1', params: { ptId: 'pt_01' } },
  { file: 'ub1_package', role: 'user', id: 'UB1', params: { ptId: 'pt_01' } },
  { file: 'popup', role: 'user', id: 'UD1', popup: true },
  { file: 'chat', role: 'user', id: 'UC1' },
  { file: 'profile_user', role: 'user', id: 'UPF1' },
  { file: 'po1', role: 'pt', id: 'PO1' },
  { file: 'pw1', role: 'pt', id: 'PW1' },
  { file: 'pi1', role: 'pt', id: 'PI1' },
];

async function jump(page, role, id, params) {
  await page.evaluate(
    ({ role, id, params }) => {
      window.__psgy.getState().jump(role, { id, params });
    },
    { role, id, params },
  );
  await page.waitForTimeout(400);
}

function stitch(inputs, dest, labels) {
  const labeled = inputs.map((p, i) => {
    const tmp = join(out, `_lbl_${i}.png`);
    const r = spawnSync(
      'ffmpeg',
      [
        '-y',
        '-i',
        p,
        '-vf',
        `pad=iw:ih+36:0:36:black,drawtext=fontfile=/System/Library/Fonts/Helvetica.ttc:text='${labels[i]}':fontcolor=white:fontsize=22:x=16:y=6`,
        tmp,
      ],
      { encoding: 'utf8' },
    );
    if (r.status !== 0) {
      console.warn('drawtext failed, stacking unlabeled', r.stderr?.slice(-400));
      return p;
    }
    return tmp;
  });
  const args = ['-y'];
  for (const p of labeled) args.push('-i', p);
  args.push('-filter_complex', `hstack=inputs=${labeled.length}`, dest);
  const r = spawnSync('ffmpeg', args, { encoding: 'utf8' });
  if (r.status !== 0) throw new Error(r.stderr?.slice(-800) || 'ffmpeg hstack failed');
}

async function main() {
  const browser = await chromium.launch({ headless: true, channel: 'chrome' });
  const page = await browser.newPage({ viewport: { width: 1680, height: 980 } });
  await page.goto(BASE, { waitUntil: 'networkidle' });
  await page.waitForTimeout(700);
  await page.evaluate(() => {
    localStorage.removeItem('psgy-proto-v2');
    localStorage.removeItem('psgy-proto-appearance-v1');
  });
  await page.reload({ waitUntil: 'networkidle' });
  await page.waitForTimeout(700);
  const hasStore = await page.evaluate(() => Boolean(window.__psgy));
  if (!hasStore) throw new Error('window.__psgy missing');
  await page.evaluate(() => window.__psgy.getState().commit({ muteTimedPopups: true, findWhatSeen: true }));

  const clips = {};
  for (const shot of SHOTS) {
    clips[shot.file] = [];
    for (const v of VARIANTS) {
      await page.evaluate((id) => window.__psgy.getState().setStyle(id), v.id);
      await page.waitForTimeout(250);
      if (shot.popup) {
        await page.evaluate(() => {
          window.__psgy.getState().commit({ muteTimedPopups: false, seenPopup: {} });
          window.__psgy.getState().clockJump('remain60');
        });
        await page.waitForTimeout(300);
      } else {
        await page.evaluate(() => window.__psgy.getState().commit({ muteTimedPopups: true }));
      }
      await jump(page, shot.role, shot.id, shot.params);
      if (shot.wait) await page.waitForTimeout(shot.wait);
      const sel = `[data-frame="${shot.role}"]`;
      const el = await page.$(sel);
      if (!el) throw new Error(`missing ${sel}`);
      const path = join(out, `_${shot.file}_${v.tag}.png`);
      await el.screenshot({ path });
      clips[shot.file].push(path);
    }
    stitch(clips[shot.file], join(out, `${shot.file}_ABC.png`), ['A Teal tươi', 'B Teal mềm', 'C Teal tối']);
    console.log('stitched', shot.file);
  }

  await page.evaluate(() => window.__psgy.getState().setStyle('fresh'));
  await page.evaluate(() => {
    const btns = [...document.querySelectorAll('button')];
    btns.find((b) => b.textContent?.trim() === 'Giao diện')?.click();
  });
  await page.waitForTimeout(400);
  const panel = await page.$('aside');
  if (panel) await panel.screenshot({ path: join(out, 'appearance_tab.png') });
  await page.evaluate(() => {
    const labels = [...document.querySelectorAll('aside div')];
    const row = labels.find((el) => el.textContent === 'Brand (teal tươi)');
    const input = row?.parentElement?.querySelector('input[type="text"], input:not([type]), input.font-mono');
    if (input) {
      input.focus();
    }
  });
  await page.evaluate(() => {
    const hex = [...document.querySelectorAll('aside input')].find(
      (el) => el instanceof HTMLInputElement && el.value?.toUpperCase() === '#0E9F87',
    );
    if (hex) {
      hex.focus();
      hex.select();
    }
  });
  await page.waitForTimeout(200);
  const contrastBox = await page.evaluateHandle(() => {
    const nodes = [...document.querySelectorAll('aside div')];
    return nodes.find((el) => el.textContent?.includes('Tương phản chữ/nền'))?.parentElement ?? null;
  });
  if (contrastBox.asElement()) {
    await contrastBox.asElement().screenshot({ path: join(out, 'appearance_contrast.png') });
  }
  if (panel) await panel.screenshot({ path: join(out, 'appearance_tab_contrast.png') });

  await browser.close();
  console.log('3C screenshots ok', out);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
