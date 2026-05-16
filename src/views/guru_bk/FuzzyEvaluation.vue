<script setup lang="ts">
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Evaluasi Fuzzy' }]

const selectedStudent = ref('Ahmad Rizky')
const evaluated = ref(true)

const students = [
  'Ahmad Rizky',
  'Budi Santoso',
  'Citra Dewi',
  'Dian Pratama',
  'Eko Wijaya',
]

const inputs = [
  { label: 'Jumlah Pelanggaran', value: 12, max: 20, unit: 'kasus', membership: 'Sedang' },
  { label: 'Frekuensi', value: 3.5, max: 5, unit: '/bulan', membership: 'Sedang' },
  { label: 'Tingkat Keparahan', value: 45, max: 100, unit: 'poin', membership: 'Sedang' },
]

const rules = [
  { condition: 'IF Jumlah=Sedang AND Frekuensi=Sedang', conclusion: 'THEN Tingkat=Sedang', fired: true, degree: 0.72 },
  { condition: 'IF Jumlah=Banyak AND Frekuensi=Tinggi', conclusion: 'THEN Tingkat=Tinggi', fired: false, degree: 0.0 },
  { condition: 'IF Jumlah=Sedikit AND Frekuensi=Rendah', conclusion: 'THEN Tingkat=Ringan', fired: false, degree: 0.0 },
  { condition: 'IF Jumlah=Sedang AND Frekuensi=Rendah', conclusion: 'THEN Tingkat=Ringan', fired: false, degree: 0.15 },
]

const result = { status: 'SEDANG', crispValue: 55, color: 'var(--amber-500)', recommendation: 'Siswa perlu mendapat perhatian lebih dari Guru BK. Lakukan konseling individual dan monitoring ketat selama minimal 2 bulan ke depan.' }

function runEvaluation() {
  evaluated.value = true
}

function getBarPct(val: number, max: number) {
  return Math.round((val / max) * 100)
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Evaluasi Fuzzy</h1>
        <p class="page-subtitle">Proses evaluasi tingkat pelanggaran siswa menggunakan logika fuzzy.</p>
      </div>

      <div class="eval-layout">
        <!-- Left Sidebar: Student Selector -->
        <div class="eval-sidebar">
          <div class="card">
            <h3 class="card-title">Pilih Siswa</h3>
            <div class="form-group">
              <label class="form-label">Nama Siswa</label>
              <select v-model="selectedStudent" class="form-select">
                <option v-for="s in students" :key="s" :value="s">{{ s }}</option>
              </select>
            </div>
            <button class="btn btn-primary eval-btn" @click="runEvaluation">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
                <path d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Jalankan Evaluasi
            </button>
          </div>
        </div>

        <!-- Main Content -->
        <div class="eval-main" v-if="evaluated">

          <!-- Step 1: Fuzzification -->
          <div class="card step-card">
            <div class="step-header">
              <div class="step-num">1</div>
              <div>
                <div class="step-title">Fuzzifikasi</div>
                <div class="step-sub">Konversi nilai crisp ke derajat keanggotaan fuzzy</div>
              </div>
            </div>
            <div class="inputs-grid">
              <div v-for="inp in inputs" :key="inp.label" class="input-card">
                <div class="input-header">
                  <span class="input-label">{{ inp.label }}</span>
                  <span class="input-membership">{{ inp.membership }}</span>
                </div>
                <div class="input-value-row">
                  <span class="input-val">{{ inp.value }}</span>
                  <span class="input-unit">{{ inp.unit }}</span>
                </div>
                <div class="progress" style="margin-top: 0.5rem;">
                  <div class="progress-bar amber-bar" :style="{ width: getBarPct(inp.value, inp.max) + '%' }"></div>
                </div>
                <div class="input-pct">{{ getBarPct(inp.value, inp.max) }}%</div>
              </div>
            </div>
          </div>

          <!-- Step 2: Inference -->
          <div class="card step-card">
            <div class="step-header">
              <div class="step-num">2</div>
              <div>
                <div class="step-title">Inferensi</div>
                <div class="step-sub">Rule yang aktif berdasarkan nilai keanggotaan</div>
              </div>
            </div>
            <div class="rules-list">
              <div
                v-for="(rule, i) in rules"
                :key="i"
                :class="['rule-card', rule.fired ? 'rule-fired' : 'rule-inactive']"
              >
                <div class="rule-badge-wrap">
                  <span :class="['rule-badge', rule.fired ? 'badge-warning' : 'badge']">
                    {{ rule.fired ? 'AKTIF' : 'TIDAK AKTIF' }}
                  </span>
                  <span class="rule-degree">α = {{ rule.degree.toFixed(2) }}</span>
                </div>
                <div class="rule-text">
                  <span class="rule-condition">{{ rule.condition }}</span>
                  <span class="rule-arrow">→</span>
                  <span class="rule-conclusion">{{ rule.conclusion }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Step 3: Defuzzification -->
          <div class="card step-card">
            <div class="step-header">
              <div class="step-num">3</div>
              <div>
                <div class="step-title">Defuzzifikasi</div>
                <div class="step-sub">Konversi output fuzzy ke nilai crisp menggunakan metode Centroid</div>
              </div>
            </div>
            <div class="defuzz-display">
              <div class="gauge-wrap">
                <svg viewBox="0 0 200 120" width="200" height="120">
                  <!-- Background arc -->
                  <path d="M 20 100 A 80 80 0 0 1 180 100" fill="none" stroke="var(--bg-elevated)" stroke-width="14" stroke-linecap="round"/>
                  <!-- Filled arc ~55% -->
                  <path d="M 20 100 A 80 80 0 0 1 130 28" fill="none" stroke="var(--amber-500)" stroke-width="14" stroke-linecap="round"/>
                  <text x="100" y="95" text-anchor="middle" font-size="24" font-weight="700" fill="var(--text-primary)">55</text>
                  <text x="100" y="112" text-anchor="middle" font-size="11" fill="var(--text-secondary)">Nilai Crisp</text>
                </svg>
              </div>
              <div class="defuzz-info">
                <div class="defuzz-status" :style="{ color: result.color }">{{ result.status }}</div>
                <div class="defuzz-method">Metode: Centroid (CoA)</div>
                <div class="defuzz-range">
                  <span class="range-low">Ringan</span>
                  <div class="range-bar">
                    <div class="range-fill" :style="{ width: result.crispValue + '%', background: result.color }"></div>
                  </div>
                  <span class="range-high">Berat</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Result Card -->
          <div class="card result-card">
            <div class="result-banner" :style="{ borderColor: result.color }">
              <div class="result-label">Hasil Evaluasi</div>
              <div class="result-status" :style="{ color: result.color }">{{ result.status }}</div>
              <div class="result-crisp">Nilai Crisp: <strong>{{ result.crispValue }}</strong> / 100</div>
            </div>
            <div class="result-body">
              <div class="result-rec">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18" style="flex-shrink:0;margin-top:2px">
                  <path d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <p>{{ result.recommendation }}</p>
              </div>
              <div class="result-actions">
                <button class="btn btn-primary">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  Buat Tindak Lanjut
                </button>
                <button class="btn btn-outline">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
                    <path d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  Cetak Hasil
                </button>
              </div>
            </div>
          </div>

        </div>

        <div class="eval-main empty-eval" v-else>
          <div class="card empty-card">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="48" height="48" style="margin:0 auto 1rem;display:block;color:var(--text-muted)">
              <path d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            <p style="text-align:center;color:var(--text-secondary)">Pilih siswa dan klik "Jalankan Evaluasi" untuk melihat hasil.</p>
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

.eval-layout { display: grid; grid-template-columns: 260px 1fr; gap: 1.5rem; align-items: start; }
.eval-sidebar .card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; }
.eval-main { display: flex; flex-direction: column; gap: 1.25rem; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; }
.card-title { font-size: 1rem; font-weight: 600; color: var(--text-primary); margin-bottom: 1rem; }
.eval-btn { width: 100%; justify-content: center; margin-top: 0.5rem; }

.step-card {}
.step-header { display: flex; align-items: flex-start; gap: 1rem; margin-bottom: 1.25rem; }
.step-num { width: 32px; height: 32px; border-radius: 50%; background: var(--primary-600); color: white; font-weight: 700; font-size: 0.9rem; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.step-title { font-weight: 700; color: var(--text-primary); font-size: 0.95rem; }
.step-sub { font-size: 0.75rem; color: var(--text-secondary); margin-top: 2px; }

.inputs-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; }
.input-card { background: var(--bg-base); border: 1px solid var(--border-color); border-radius: 8px; padding: 0.875rem; }
.input-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; }
.input-label { font-size: 0.75rem; color: var(--text-secondary); font-weight: 500; }
.input-membership { font-size: 0.7rem; background: color-mix(in srgb, var(--amber-500) 15%, transparent); color: var(--amber-500); padding: 1px 6px; border-radius: 4px; font-weight: 600; }
.input-value-row { display: flex; align-items: baseline; gap: 0.25rem; }
.input-val { font-size: 1.5rem; font-weight: 700; color: var(--text-primary); }
.input-unit { font-size: 0.75rem; color: var(--text-secondary); }
.input-pct { font-size: 0.7rem; color: var(--text-muted); margin-top: 4px; text-align: right; }
.progress { background: var(--bg-elevated); border-radius: 999px; height: 6px; overflow: hidden; }
.progress-bar { height: 100%; border-radius: 999px; }
.amber-bar { background: var(--amber-500); }

.rules-list { display: flex; flex-direction: column; gap: 0.75rem; }
.rule-card { border-radius: 8px; padding: 0.875rem; border: 1.5px solid var(--border-color); }
.rule-fired { border-color: var(--amber-500); background: color-mix(in srgb, var(--amber-500) 8%, transparent); }
.rule-inactive { opacity: 0.6; }
.rule-badge-wrap { display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.4rem; }
.rule-badge { font-size: 0.7rem; padding: 2px 8px; border-radius: 4px; font-weight: 700; }
.rule-degree { font-size: 0.75rem; color: var(--text-secondary); }
.rule-text { font-size: 0.85rem; color: var(--text-primary); display: flex; flex-wrap: wrap; gap: 0.4rem; align-items: center; }
.rule-condition { color: var(--primary-600); font-weight: 500; }
.rule-arrow { color: var(--text-muted); }
.rule-conclusion { color: var(--amber-500); font-weight: 500; }

.defuzz-display { display: flex; align-items: center; gap: 2rem; }
.gauge-wrap { flex-shrink: 0; }
.defuzz-info { flex: 1; }
.defuzz-status { font-size: 1.75rem; font-weight: 800; margin-bottom: 4px; }
.defuzz-method { font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 1rem; }
.defuzz-range { display: flex; align-items: center; gap: 0.75rem; }
.range-low, .range-high { font-size: 0.75rem; color: var(--text-secondary); white-space: nowrap; }
.range-bar { flex: 1; background: var(--bg-elevated); border-radius: 999px; height: 8px; overflow: hidden; }
.range-fill { height: 100%; border-radius: 999px; }

.result-card { border-top: 4px solid var(--amber-500); }
.result-banner { display: flex; flex-direction: column; align-items: center; padding-bottom: 1.25rem; margin-bottom: 1.25rem; border-bottom: 1px solid var(--border-color); }
.result-label { font-size: 0.8rem; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.06em; margin-bottom: 0.25rem; }
.result-status { font-size: 2.5rem; font-weight: 800; }
.result-crisp { font-size: 0.9rem; color: var(--text-secondary); margin-top: 0.25rem; }
.result-body { display: flex; flex-direction: column; gap: 1rem; }
.result-rec { display: flex; gap: 0.75rem; padding: 1rem; background: color-mix(in srgb, var(--amber-500) 8%, transparent); border-radius: 8px; border: 1px solid color-mix(in srgb, var(--amber-500) 25%, transparent); color: var(--text-primary); font-size: 0.9rem; line-height: 1.5; }
.result-actions { display: flex; gap: 0.75rem; flex-wrap: wrap; }

.empty-card { padding: 3rem; text-align: center; }

.btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.875rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: var(--primary-600); color: white; }
.btn-outline { background: transparent; color: var(--text-primary); border: 1.5px solid var(--border-color); }
.form-group { margin-bottom: 0.75rem; }

@media (max-width: 900px) {
  .eval-layout { grid-template-columns: 1fr; }
  .inputs-grid { grid-template-columns: 1fr; }
  .defuzz-display { flex-direction: column; }
}
</style>
