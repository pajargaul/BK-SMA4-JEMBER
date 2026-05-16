<script setup lang="ts">
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Siswa' }, { label: 'Dashboard' }]

const score = 78
const scoreColor = score >= 70 ? 'var(--green-500)' : score >= 40 ? 'var(--amber-500)' : 'var(--red-500)'

// SVG arc for semicircle gauge (radius=80, cx=100, cy=100)
// 0% = left side (angle=-180deg), 100% = right side (angle=0)
// Semicircle: from (20, 100) to (180, 100) clockwise over top
const gaugeR = 80
const cx = 100
const cy = 100
const pct = score / 100
function polarToCartesian(centerX: number, centerY: number, radius: number, angleDeg: number) {
  const rad = (angleDeg - 90) * (Math.PI / 180)
  return {
    x: centerX + radius * Math.cos(rad),
    y: centerY + radius * Math.sin(rad),
  }
}

// Semicircle from 180deg to 360deg (left to right, going over top)
const start = polarToCartesian(cx, cy, gaugeR, 180)
const end = polarToCartesian(cx, cy, gaugeR, 360)
const arcBg = `M ${start.x} ${start.y} A ${gaugeR} ${gaugeR} 0 0 1 ${end.x} ${end.y}`

const fillAngle = 180 + pct * 180
const fillEnd = polarToCartesian(cx, cy, gaugeR, fillAngle)
const largeArc = pct > 0.5 ? 1 : 0
const arcFill = `M ${start.x} ${start.y} A ${gaugeR} ${gaugeR} 0 ${largeArc} 1 ${fillEnd.x} ${fillEnd.y}`

const stats = [
  { label: 'Total Pelanggaran', value: 5, icon: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z', color: 'var(--red-500)' },
  { label: 'Status Perilaku', value: 'Sedang', icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z', color: 'var(--amber-500)' },
  { label: 'Riwayat Konseling', value: 2, icon: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z', color: 'var(--teal-500)' },
  { label: 'Tingkat Kedisiplinan', value: '78%', icon: 'M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z', color: 'var(--green-500)' },
]

const quotes = [
  { text: 'Disiplin adalah jembatan antara tujuan dan pencapaian.', author: 'Jim Rohn' },
  { text: 'Kualitas hidupmu ditentukan oleh kualitas kebiasaanmu sehari-hari.', author: 'Aristoteles' },
  { text: 'Orang sukses adalah orang yang punya kebiasaan melakukan hal-hal yang tidak ingin dilakukan oleh orang gagal.', author: 'Thomas Edison' },
]
const quote = quotes[Math.floor(Math.random() * quotes.length)]

const activities = [
  { type: 'violation', desc: 'Terlambat masuk sekolah', date: '10/05/2026', color: 'var(--red-500)', icon: '⚠' },
  { type: 'counseling', desc: 'Konseling Individual - Sesi 1', date: '11/05/2026', color: 'var(--teal-500)', icon: '💬' },
  { type: 'violation', desc: 'Tidak mengerjakan PR', date: '13/05/2026', color: 'var(--amber-500)', icon: '⚠' },
  { type: 'counseling', desc: 'Konseling Individual - Sesi 2', date: '14/05/2026', color: 'var(--teal-500)', icon: '💬' },
  { type: 'followup', desc: 'Jadwal Pemanggilan Orang Tua', date: '22/05/2026', color: 'var(--primary-600)', icon: '📋' },
]
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Dashboard Siswa</h1>
        <p class="page-subtitle">Pantau perkembangan perilaku dan status bimbingan konseling kamu.</p>
      </div>

      <!-- Stats -->
      <div class="stats-grid">
        <div v-for="stat in stats" :key="stat.label" class="stat-card card">
          <div class="stat-icon" :style="{ background: stat.color }">
            <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" width="18" height="18">
              <path :d="stat.icon" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div>
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>
      </div>

      <div class="dash-grid">
        <!-- Gauge -->
        <div class="card gauge-card">
          <h3 class="card-title">Skor Kedisiplinan</h3>
          <div class="gauge-wrap">
            <svg viewBox="0 0 200 120" width="220" height="132">
              <!-- Background arc -->
              <path :d="arcBg" fill="none" stroke="var(--bg-elevated)" stroke-width="16" stroke-linecap="round"/>
              <!-- Filled arc -->
              <path :d="arcFill" fill="none" :stroke="scoreColor" stroke-width="16" stroke-linecap="round"/>
              <!-- Score text -->
              <text x="100" y="90" text-anchor="middle" font-size="28" font-weight="800" :fill="scoreColor">{{ score }}</text>
              <text x="100" y="108" text-anchor="middle" font-size="11" fill="var(--text-secondary)">dari 100</text>
            </svg>
            <div class="gauge-labels">
              <span class="gauge-lbl-low">Buruk</span>
              <span class="gauge-lbl-mid">Sedang</span>
              <span class="gauge-lbl-high">Baik</span>
            </div>
          </div>
          <div class="gauge-status" :style="{ color: scoreColor }">
            <span v-if="score >= 70">Disiplin Baik</span>
            <span v-else-if="score >= 40">Perlu Perhatian</span>
            <span v-else>Kritis</span>
          </div>
        </div>

        <!-- Motivation -->
        <div class="card motivation-card">
          <h3 class="card-title">Motivasi Hari Ini</h3>
          <div class="quote-box">
            <div class="quote-emoji">💡</div>
            <blockquote class="quote-text">"{{ quote.text }}"</blockquote>
            <div class="quote-author">— {{ quote.author }}</div>
          </div>
          <div class="tip-box">
            <span class="tip-icon">⭐</span>
            <p class="tip-text">Jaga perilakumu setiap hari. Skor kamu saat ini <strong>{{ score }}/100</strong>. Pertahankan dan tingkatkan!</p>
          </div>
        </div>

        <!-- Activity Timeline -->
        <div class="card activity-card">
          <h3 class="card-title">Aktivitas Terbaru</h3>
          <div class="activity-list">
            <div v-for="(act, i) in activities" :key="i" class="act-item">
              <div class="act-dot" :style="{ background: act.color }"></div>
              <div class="act-content">
                <div class="act-desc">{{ act.desc }}</div>
                <div class="act-date">{{ act.date }}</div>
              </div>
              <div class="act-type-tag" :style="{ color: act.color, background: act.color + '18' }">
                {{ act.type === 'violation' ? 'Pelanggaran' : act.type === 'counseling' ? 'Konseling' : 'Tindak Lanjut' }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-container { display: flex; flex-direction: column; min-height: 100vh; background: var(--bg-base); }
.page-content { padding: 1.5rem 2rem; flex: 1; }
.page-header { margin-bottom: 1.5rem; }

.stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
.stat-card { display: flex; align-items: center; gap: 0.875rem; padding: 1rem 1.25rem; }
.stat-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.stat-value { font-size: 1.5rem; font-weight: 700; color: var(--text-primary); line-height: 1; }
.stat-label { font-size: 0.75rem; color: var(--text-secondary); margin-top: 2px; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; }
.card-title { font-size: 0.95rem; font-weight: 600; color: var(--text-primary); margin-bottom: 1rem; }

.dash-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1.25rem; }

.gauge-card { display: flex; flex-direction: column; align-items: center; }
.gauge-wrap { display: flex; flex-direction: column; align-items: center; }
.gauge-labels { display: flex; justify-content: space-between; width: 220px; font-size: 0.7rem; color: var(--text-muted); margin-top: -8px; }
.gauge-status { font-size: 1rem; font-weight: 700; margin-top: 0.5rem; }

.motivation-card {}
.quote-box { background: var(--bg-base); border-radius: 10px; padding: 1.25rem; margin-bottom: 1rem; text-align: center; border: 1px solid var(--border-color); }
.quote-emoji { font-size: 1.75rem; margin-bottom: 0.5rem; }
.quote-text { font-size: 0.9rem; font-style: italic; color: var(--text-primary); line-height: 1.6; margin: 0 0 0.5rem; }
.quote-author { font-size: 0.75rem; color: var(--text-muted); font-weight: 600; }
.tip-box { display: flex; gap: 0.5rem; padding: 0.875rem; background: color-mix(in srgb, var(--primary-600) 8%, transparent); border-radius: 8px; border: 1px solid color-mix(in srgb, var(--primary-600) 20%, transparent); }
.tip-icon { font-size: 1rem; flex-shrink: 0; }
.tip-text { font-size: 0.82rem; color: var(--text-secondary); line-height: 1.5; }

.activity-list { display: flex; flex-direction: column; gap: 0.75rem; }
.act-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.6rem 0.75rem; background: var(--bg-base); border-radius: 8px; border: 1px solid var(--border-color); }
.act-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
.act-content { flex: 1; min-width: 0; }
.act-desc { font-size: 0.82rem; font-weight: 600; color: var(--text-primary); }
.act-date { font-size: 0.7rem; color: var(--text-muted); }
.act-type-tag { font-size: 0.7rem; font-weight: 600; padding: 2px 8px; border-radius: 4px; white-space: nowrap; }

@media (max-width: 1100px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
  .dash-grid { grid-template-columns: 1fr; }
}
</style>
