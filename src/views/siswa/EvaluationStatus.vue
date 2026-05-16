<script setup lang="ts">
import { ref, onMounted } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Siswa' }, { label: 'Status Evaluasi' }]

const score = ref(0)
const targetScore = 55

onMounted(() => {
  setTimeout(() => {
    const interval = setInterval(() => {
      if (score.value < targetScore) {
        score.value += 1
      } else {
        clearInterval(interval)
      }
    }, 20)
  }, 300)
})

const statusLabel = 'PERLU PERHATIAN'
const statusColor = 'var(--amber-500)'
const statusBg = 'color-mix(in srgb, var(--amber-500) 12%, transparent)'
const statusBorder = 'color-mix(in srgb, var(--amber-500) 30%, transparent)'

const factors = [
  { label: 'Jumlah Pelanggaran', value: 12, unit: 'kasus', icon: '📋', color: 'var(--red-500)', membership: 'Sedang' },
  { label: 'Frekuensi', value: 3.5, unit: '/bulan', icon: '📅', color: 'var(--amber-500)', membership: 'Sedang' },
  { label: 'Tingkat Keparahan', value: 45, unit: 'poin', icon: '⚡', color: 'var(--amber-500)', membership: 'Sedang' },
]

const recommendation = 'Berdasarkan hasil evaluasi, kamu perlu mendapat bimbingan lebih intensif dari Guru BK. Disarankan untuk mengikuti sesi konseling individual dan menjaga perilaku secara konsisten ke depannya.'

const nextEvalDate = '15 Juni 2026'

const history = [
  { date: '15/05/2026', status: 'Perlu Perhatian', score: 55, evaluator: 'Dra. Siti Rahayu, M.Pd.' },
  { date: '15/04/2026', status: 'Perlu Perhatian', score: 62, evaluator: 'Dra. Siti Rahayu, M.Pd.' },
  { date: '15/03/2026', status: 'Normal', score: 78, evaluator: 'Dra. Siti Rahayu, M.Pd.' },
  { date: '15/02/2026', status: 'Normal', score: 82, evaluator: 'Dra. Siti Rahayu, M.Pd.' },
]

function getHistoryBadge(status: string) {
  if (status === 'Normal') return 'badge-success'
  if (status === 'Perlu Perhatian') return 'badge-warning'
  return 'badge-danger'
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Status Evaluasi</h1>
        <p class="page-subtitle">Hasil evaluasi fuzzy atas tingkat pelanggaran dan kedisiplinanmu.</p>
      </div>

      <!-- Main Result Card -->
      <div class="result-card card">
        <div class="result-banner" :style="{ background: statusBg, borderColor: statusBorder }">
          <div class="result-label">Status Evaluasi Terkini</div>
          <div class="result-status" :style="{ color: statusColor }">{{ statusLabel }}</div>
          <div class="result-date">Dievaluasi pada 15 Mei 2026</div>
        </div>

        <!-- Score Bar -->
        <div class="score-section">
          <div class="score-header">
            <span class="score-title">Skor Evaluasi</span>
            <span class="score-num" :style="{ color: statusColor }">{{ score }}<span class="score-max">/100</span></span>
          </div>
          <div class="progress score-bar">
            <div
              class="progress-bar"
              :style="{ width: score + '%', background: statusColor, transition: 'width 0.05s linear' }"
            ></div>
          </div>
          <div class="score-scale">
            <span>0</span><span>25</span><span>50</span><span>75</span><span>100</span>
          </div>
        </div>

        <!-- Factor Cards -->
        <div class="factors-section">
          <h4 class="factors-title">Faktor Input Evaluasi</h4>
          <div class="factors-grid">
            <div v-for="f in factors" :key="f.label" class="factor-card">
              <div class="factor-icon">{{ f.icon }}</div>
              <div class="factor-value" :style="{ color: f.color }">{{ f.value }}</div>
              <div class="factor-unit">{{ f.unit }}</div>
              <div class="factor-label">{{ f.label }}</div>
              <div class="factor-membership" :style="{ color: f.color, background: f.color + '18' }">{{ f.membership }}</div>
            </div>
          </div>
        </div>

        <!-- Recommendation -->
        <div class="rec-section">
          <h4 class="rec-title">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
              <path d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Rekomendasi Guru BK
          </h4>
          <p class="rec-text">{{ recommendation }}</p>
        </div>

        <!-- Next Evaluation -->
        <div class="next-eval">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16" style="flex-shrink:0;color:var(--text-muted)">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
          <span>Evaluasi berikutnya: <strong>{{ nextEvalDate }}</strong></span>
        </div>
      </div>

      <!-- History Table -->
      <div class="card">
        <h3 class="section-title">Riwayat Evaluasi</h3>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Tanggal</th>
                <th>Status</th>
                <th>Skor</th>
                <th>Evaluator</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(h, i) in history" :key="i">
                <td>{{ h.date }}</td>
                <td>
                  <span :class="['badge', getHistoryBadge(h.status)]">{{ h.status }}</span>
                </td>
                <td>
                  <span class="score-cell" :style="{ color: h.score >= 70 ? 'var(--green-500)' : h.score >= 40 ? 'var(--amber-500)' : 'var(--red-500)' }">
                    {{ h.score }}
                  </span>
                </td>
                <td>{{ h.evaluator }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-container { display: flex; flex-direction: column; min-height: 100vh; background: var(--bg-base); }
.page-content { padding: 1.5rem 2rem; flex: 1; }
.page-header { margin-bottom: 1.5rem; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; }

.result-card { display: flex; flex-direction: column; gap: 1.5rem; }
.result-banner { border: 1.5px solid; border-radius: 10px; padding: 1.5rem; text-align: center; }
.result-label { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.06em; color: var(--text-secondary); margin-bottom: 0.5rem; }
.result-status { font-size: 2.25rem; font-weight: 800; }
.result-date { font-size: 0.8rem; color: var(--text-muted); margin-top: 0.5rem; }

.score-section {}
.score-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; }
.score-title { font-size: 0.875rem; font-weight: 600; color: var(--text-primary); }
.score-num { font-size: 1.5rem; font-weight: 800; }
.score-max { font-size: 0.9rem; color: var(--text-muted); }
.progress { background: var(--bg-elevated); border-radius: 999px; height: 12px; overflow: hidden; }
.progress-bar { height: 100%; border-radius: 999px; }
.score-bar { height: 12px; }
.score-scale { display: flex; justify-content: space-between; font-size: 0.7rem; color: var(--text-muted); margin-top: 4px; }

.factors-section {}
.factors-title { font-size: 0.875rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.875rem; }
.factors-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; }
.factor-card { background: var(--bg-base); border: 1px solid var(--border-color); border-radius: 10px; padding: 1rem; text-align: center; }
.factor-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }
.factor-value { font-size: 1.5rem; font-weight: 800; }
.factor-unit { font-size: 0.75rem; color: var(--text-muted); }
.factor-label { font-size: 0.75rem; color: var(--text-secondary); margin: 6px 0 4px; font-weight: 500; }
.factor-membership { font-size: 0.7rem; font-weight: 700; padding: 2px 10px; border-radius: 4px; display: inline-block; }

.rec-section { background: var(--bg-base); border-radius: 10px; padding: 1.25rem; border: 1px solid var(--border-color); }
.rec-title { display: flex; align-items: center; gap: 0.5rem; font-size: 0.875rem; font-weight: 700; color: var(--text-primary); margin-bottom: 0.5rem; }
.rec-text { font-size: 0.875rem; color: var(--text-secondary); line-height: 1.6; }

.next-eval { display: flex; align-items: center; gap: 0.5rem; font-size: 0.875rem; color: var(--text-secondary); border-top: 1px solid var(--border-color); padding-top: 1rem; }

.section-title { font-size: 0.95rem; font-weight: 600; color: var(--text-primary); margin-bottom: 1rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-color); }
.table-container { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
.data-table th { background: var(--bg-base); color: var(--text-secondary); font-weight: 600; text-align: left; padding: 0.65rem 1rem; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.04em; border-bottom: 1px solid var(--border-color); }
.data-table td { padding: 0.875rem 1rem; border-bottom: 1px solid var(--border-color); color: var(--text-primary); }
.data-table tbody tr:last-child td { border-bottom: none; }
.score-cell { font-weight: 700; font-size: 0.95rem; }

@media (max-width: 700px) { .factors-grid { grid-template-columns: 1fr; } }
</style>
