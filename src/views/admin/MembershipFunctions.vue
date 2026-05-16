<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Fungsi Keanggotaan'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Fungsi Keanggotaan</h1>
          <p class="page-subtitle">Visualisasi dan konfigurasi fungsi keanggotaan fuzzy</p>
        </div>
      </div>

      <!-- Variable Selector -->
      <div class="var-tabs">
        <button
          v-for="v in variables" :key="v.id"
          :class="['var-tab', activeVar === v.id ? 'active' : '']"
          @click="activeVar = v.id"
        >
          <span class="tab-dot" :style="{background: v.color}"></span>
          {{ v.name }}
          <span :class="v.type === 'input' ? 'badge badge-primary' : 'badge badge-warning'">
            {{ v.type === 'input' ? 'Input' : 'Output' }}
          </span>
        </button>
      </div>

      <!-- Active Variable Display -->
      <div v-for="v in variables" :key="v.id" v-show="activeVar === v.id" class="var-section">
        <div class="card mf-card">
          <div class="mf-card-header">
            <div>
              <h3>{{ v.name }}</h3>
              <p class="text-muted">Rentang: {{ v.min }} – {{ v.max }} {{ v.unit }}</p>
            </div>
          </div>

          <!-- SVG Graph -->
          <div class="graph-container">
            <div class="graph-y-label">Derajat Keanggotaan (μ)</div>
            <div class="graph-wrapper">
              <div class="y-axis">
                <span>1.0</span>
                <span>0.5</span>
                <span>0.0</span>
              </div>
              <div class="graph-area">
                <svg :viewBox="`0 0 ${SVG_W} ${SVG_H}`" class="mf-svg" preserveAspectRatio="none">
                  <!-- Grid lines -->
                  <line v-for="y in [0.25, 0.5, 0.75, 1.0]" :key="y"
                    x1="0" :y1="toSvgY(y)" :x2="SVG_W" :y2="toSvgY(y)"
                    stroke="#f1f5f9" stroke-width="1" />
                  <!-- MF polygons -->
                  <polygon
                    v-for="mf in v.mfs" :key="mf.name"
                    :points="mfPoints(mf, v.min, v.max)"
                    :fill="mf.color + '30'"
                    :stroke="mf.color"
                    stroke-width="2"
                    stroke-linejoin="round"
                  />
                  <!-- MF labels -->
                  <text
                    v-for="mf in v.mfs" :key="mf.name + '_label'"
                    :x="toSvgX(mfCenter(mf), v.min, v.max)"
                    :y="toSvgY(1.0) - 8"
                    text-anchor="middle"
                    :fill="mf.color"
                    font-size="11"
                    font-weight="600"
                  >{{ mf.name }}</text>
                  <!-- X axis -->
                  <line x1="0" :y1="toSvgY(0)" :x2="SVG_W" :y2="toSvgY(0)" stroke="#cbd5e1" stroke-width="1.5" />
                </svg>
                <!-- X axis labels -->
                <div class="x-axis">
                  <span v-for="tick in xTicks(v)" :key="tick">{{ tick }}</span>
                </div>
              </div>
            </div>
            <div class="graph-x-label">{{ v.name }} ({{ v.unit }})</div>
          </div>

          <!-- MF Table -->
          <div class="mf-table-section">
            <h4>Parameter Fungsi Keanggotaan</h4>
            <table class="mf-table">
              <thead>
                <tr>
                  <th>Nama</th>
                  <th>Tipe</th>
                  <th>Parameter</th>
                  <th>Warna</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="mf in v.mfs" :key="mf.name">
                  <td>
                    <div class="mf-name-cell">
                      <span class="mf-dot" :style="{background: mf.color}"></span>
                      <strong>{{ mf.name }}</strong>
                    </div>
                  </td>
                  <td><span class="badge badge-primary">{{ mf.type }}</span></td>
                  <td class="text-mono">[{{ mf.params.join(', ') }}]</td>
                  <td><div class="color-swatch" :style="{background: mf.color}"></div></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const SVG_W = 500
const SVG_H = 160
const PAD = 20

const activeVar = ref(1)

const variables = ref([
  {
    id: 1, name: 'Jumlah Pelanggaran', type: 'input', min: 0, max: 50, unit: 'pelanggaran', color: '#2563EB',
    mfs: [
      { name: 'Sedikit', type: 'trapezoid', params: [0, 0, 15, 25], color: '#22c55e' },
      { name: 'Sedang', type: 'triangle', params: [15, 25, 35], color: '#f59e0b' },
      { name: 'Banyak', type: 'trapezoid', params: [30, 40, 50, 50], color: '#ef4444' },
    ]
  },
  {
    id: 2, name: 'Frekuensi Pelanggaran', type: 'input', min: 0, max: 12, unit: 'kali/bulan', color: '#14B8A6',
    mfs: [
      { name: 'Rendah', type: 'trapezoid', params: [0, 0, 2, 4], color: '#22c55e' },
      { name: 'Sedang', type: 'triangle', params: [3, 6, 9], color: '#f59e0b' },
      { name: 'Tinggi', type: 'trapezoid', params: [8, 10, 12, 12], color: '#ef4444' },
    ]
  },
  {
    id: 3, name: 'Tingkat Keparahan', type: 'input', min: 0, max: 100, unit: 'poin', color: '#F59E0B',
    mfs: [
      { name: 'Ringan', type: 'trapezoid', params: [0, 0, 20, 35], color: '#22c55e' },
      { name: 'Sedang', type: 'triangle', params: [25, 50, 75], color: '#f59e0b' },
      { name: 'Berat', type: 'trapezoid', params: [65, 80, 100, 100], color: '#ef4444' },
    ]
  },
  {
    id: 4, name: 'Tingkat Pelanggaran', type: 'output', min: 0, max: 100, unit: 'nilai', color: '#8B5CF6',
    mfs: [
      { name: 'Ringan', type: 'trapezoid', params: [0, 0, 25, 40], color: '#22c55e' },
      { name: 'Sedang', type: 'triangle', params: [30, 50, 70], color: '#f59e0b' },
      { name: 'Berat', type: 'trapezoid', params: [60, 75, 100, 100], color: '#ef4444' },
    ]
  },
])

const toSvgX = (val, min, max) => PAD + ((val - min) / (max - min)) * (SVG_W - PAD * 2)
const toSvgY = (mu) => PAD + (1 - mu) * (SVG_H - PAD * 2)

const mfPoints = (mf, min, max) => {
  const pts = mf.type === 'triangle'
    ? [[mf.params[0], 0], [mf.params[1], 1], [mf.params[2], 0]]
    : [[mf.params[0], 0], [mf.params[1], 1], [mf.params[2], 1], [mf.params[3], 0]]
  return pts.map(([x, y]) => `${toSvgX(x, min, max)},${toSvgY(y)}`).join(' ')
}

const mfCenter = (mf) => {
  if (mf.type === 'triangle') return mf.params[1]
  return (mf.params[1] + mf.params[2]) / 2
}

const xTicks = (v) => {
  const count = 5
  const step = (v.max - v.min) / count
  return Array.from({ length: count + 1 }, (_, i) => Math.round(v.min + i * step))
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1100px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.var-tabs { display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap; }
.var-tab { display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; border-radius: 10px; border: 1px solid #e2e8f0; background: #fff; cursor: pointer; font-size: 13px; font-weight: 500; color: #64748b; transition: all 0.2s; }
.var-tab.active { background: #eff6ff; border-color: #bfdbfe; color: #1d4ed8; }
.var-tab:hover:not(.active) { background: #f8fafc; }
.tab-dot { width: 8px; height: 8px; border-radius: 50%; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.mf-card { overflow: hidden; }
.mf-card-header { padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.mf-card-header h3 { font-size: 16px; font-weight: 600; margin: 0 0 4px; }
.text-muted { color: #64748b; font-size: 13px; margin: 0; }
.graph-container { padding: 20px 24px; }
.graph-y-label { font-size: 11px; color: #94a3b8; text-align: center; margin-bottom: 8px; }
.graph-wrapper { display: flex; gap: 8px; }
.y-axis { display: flex; flex-direction: column; justify-content: space-between; padding: 8px 0; font-size: 11px; color: #94a3b8; text-align: right; width: 32px; }
.graph-area { flex: 1; }
.mf-svg { width: 100%; height: 160px; display: block; }
.x-axis { display: flex; justify-content: space-between; font-size: 11px; color: #94a3b8; padding: 4px 0; }
.graph-x-label { font-size: 11px; color: #94a3b8; text-align: center; margin-top: 4px; }
.mf-table-section { padding: 0 24px 20px; }
.mf-table-section h4 { font-size: 13px; font-weight: 600; color: #374151; margin: 0 0 12px; }
.mf-table { width: 100%; border-collapse: collapse; }
.mf-table th { padding: 8px 12px; text-align: left; font-size: 11px; font-weight: 600; color: #94a3b8; text-transform: uppercase; border-bottom: 1px solid #f1f5f9; }
.mf-table td { padding: 10px 12px; font-size: 13px; border-bottom: 1px solid #f8fafc; }
.mf-table tr:last-child td { border-bottom: none; }
.mf-name-cell { display: flex; align-items: center; gap: 8px; }
.mf-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
.text-mono { font-family: 'Courier New', monospace; font-size: 12px; color: #475569; }
.color-swatch { width: 24px; height: 24px; border-radius: 6px; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.badge-primary { background: #eff6ff; color: #1d4ed8; }
.badge-warning { background: #fffbeb; color: #92400e; }
</style>
