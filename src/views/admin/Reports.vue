<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Laporan'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Laporan Pelanggaran</h1>
          <p class="page-subtitle">Rekap dan analisis data pelanggaran siswa</p>
        </div>
        <div class="download-group">
          <button class="btn btn-outline" @click="downloadPDF">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            PDF
          </button>
          <button class="btn btn-outline" @click="downloadExcel">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 21V9"/></svg>
            Excel
          </button>
        </div>
      </div>

      <!-- Filters -->
      <div class="card filter-bar">
        <div class="filter-group">
          <label class="filter-label">Dari Tanggal</label>
          <input v-model="filters.dateFrom" type="date" class="form-input" />
        </div>
        <div class="filter-group">
          <label class="filter-label">Sampai Tanggal</label>
          <input v-model="filters.dateTo" type="date" class="form-input" />
        </div>
        <div class="filter-group">
          <label class="filter-label">Kelas</label>
          <select v-model="filters.class" class="form-select">
            <option value="">Semua Kelas</option>
            <option v-for="cls in classes" :key="cls" :value="cls">{{ cls }}</option>
          </select>
        </div>
        <div class="filter-group">
          <label class="filter-label">Kategori</label>
          <select v-model="filters.category" class="form-select">
            <option value="">Semua Kategori</option>
            <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
          </select>
        </div>
        <button class="btn btn-primary filter-btn" @click="applyFilter">Terapkan</button>
      </div>

      <!-- Summary Stats -->
      <div class="stats-grid">
        <div class="stat-card card" v-for="stat in summaryStats" :key="stat.label">
          <div class="stat-icon" :style="{background: stat.color + '20', color: stat.color}">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" v-html="stat.icon"></svg>
          </div>
          <div class="stat-info">
            <p class="stat-label">{{ stat.label }}</p>
            <p class="stat-value">{{ stat.value }}</p>
            <p class="stat-change" :class="stat.trend === 'up' ? 'trend-up' : 'trend-down'">
              {{ stat.trend === 'up' ? '↑' : '↓' }} {{ stat.change }} dari bulan lalu
            </p>
          </div>
        </div>
      </div>

      <!-- Charts Row -->
      <div class="charts-row">
        <!-- Bar Chart -->
        <div class="card chart-card">
          <div class="chart-header">
            <h3>Pelanggaran per Bulan</h3>
            <span class="badge badge-primary">2025</span>
          </div>
          <div class="bar-chart">
            <div v-for="(item, i) in monthlyData" :key="i" class="bar-column">
              <div class="bar-label-top">{{ item.count }}</div>
              <div class="bar-wrap">
                <div
                  class="bar"
                  :style="{height: (item.count / maxCount * 100) + '%', background: barColor(i)}"
                ></div>
              </div>
              <div class="bar-label-bottom">{{ item.month }}</div>
            </div>
          </div>
        </div>

        <!-- Category Distribution -->
        <div class="card chart-card">
          <div class="chart-header">
            <h3>Distribusi Kategori</h3>
          </div>
          <div class="category-dist">
            <div v-for="cat in categoryData" :key="cat.name" class="dist-item">
              <div class="dist-info">
                <span class="dist-name">{{ cat.name }}</span>
                <span class="dist-count">{{ cat.count }} kasus</span>
              </div>
              <div class="dist-bar-bg">
                <div class="dist-bar-fill" :style="{width: (cat.count / maxCatCount * 100) + '%', background: cat.color}"></div>
              </div>
              <span class="dist-pct">{{ Math.round(cat.count / totalCases * 100) }}%</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Top Violators -->
      <div class="card">
        <div class="section-header">
          <h3>Siswa dengan Pelanggaran Terbanyak</h3>
          <span class="badge badge-danger">Top 5</span>
        </div>
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Siswa</th>
              <th>Kelas</th>
              <th>Total Pelanggaran</th>
              <th>Total Poin</th>
              <th>Status Risiko</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(s, i) in topViolators" :key="s.id">
              <td>
                <div class="rank-badge" :class="['rank-' + (i+1)]">{{ i + 1 }}</div>
              </td>
              <td>
                <div class="user-cell">
                  <div class="avatar" :style="{background: avatarColors[i % avatarColors.length]}">{{ s.name[0] }}</div>
                  {{ s.name }}
                </div>
              </td>
              <td><span class="badge badge-primary">{{ s.class }}</span></td>
              <td>{{ s.violations }} kali</td>
              <td><strong>{{ s.points }}</strong></td>
              <td><span :class="riskBadge(s.points)">{{ riskLabel(s.points) }}</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const classes = ['X-A', 'X-B', 'XI-A', 'XI-B', 'XII-A', 'XII-B']
const categories = ['Kedisiplinan', 'Akademik', 'Penampilan', 'Perilaku', 'Teknologi', 'Sosial']
const avatarColors = ['#2563EB','#14B8A6','#F59E0B','#EF4444','#8B5CF6']

const filters = ref({ dateFrom: '2025-01-01', dateTo: '2025-12-31', class: '', category: '' })
const applyFilter = () => console.log('Applying filter', filters.value)
const downloadPDF = () => alert('Mengunduh laporan PDF...')
const downloadExcel = () => alert('Mengunduh laporan Excel...')

const summaryStats = ref([
  { label: 'Total Pelanggaran', value: '248', change: '12%', trend: 'up', color: '#ef4444', icon: '<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>' },
  { label: 'Siswa Terlibat', value: '87', change: '5%', trend: 'up', color: '#f59e0b', icon: '<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>' },
  { label: 'Rata-rata Poin', value: '18.4', change: '2.1', trend: 'down', color: '#14B8A6', icon: '<line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>' },
  { label: 'Kasus Berat', value: '24', change: '3', trend: 'down', color: '#8B5CF6', icon: '<path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0 1 12 2.944a11.955 11.955 0 0 1-8.618 3.04A12.02 12.02 0 0 0 3 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>' },
])

const monthlyData = ref([
  { month: 'Jan', count: 18 }, { month: 'Feb', count: 24 }, { month: 'Mar', count: 20 },
  { month: 'Apr', count: 31 }, { month: 'Mei', count: 28 }, { month: 'Jun', count: 15 },
  { month: 'Jul', count: 22 }, { month: 'Agt', count: 35 }, { month: 'Sep', count: 27 },
  { month: 'Okt', count: 19 }, { month: 'Nov', count: 23 }, { month: 'Des', count: 6 },
])
const maxCount = computed(() => Math.max(...monthlyData.value.map(m => m.count)))
const barColor = (i) => {
  const colors = ['#2563EB','#14B8A6','#2563EB','#F59E0B','#2563EB','#14B8A6','#2563EB','#EF4444','#2563EB','#14B8A6','#2563EB','#8B5CF6']
  return colors[i] || '#2563EB'
}

const categoryData = ref([
  { name: 'Kedisiplinan', count: 82, color: '#2563EB' },
  { name: 'Perilaku', count: 54, color: '#EF4444' },
  { name: 'Akademik', count: 47, color: '#14B8A6' },
  { name: 'Penampilan', count: 38, color: '#F59E0B' },
  { name: 'Teknologi', count: 16, color: '#8B5CF6' },
  { name: 'Sosial', count: 11, color: '#EC4899' },
])
const maxCatCount = computed(() => Math.max(...categoryData.value.map(c => c.count)))
const totalCases = computed(() => categoryData.value.reduce((sum, c) => sum + c.count, 0))

const topViolators = ref([
  { id: 1, name: 'Cahyo Nugroho', class: 'X-B', violations: 12, points: 65 },
  { id: 2, name: 'Haris Maulana', class: 'XII-B', violations: 10, points: 58 },
  { id: 3, name: 'Eka Saputra', class: 'XI-A', violations: 8, points: 45 },
  { id: 4, name: 'Gita Wulandari', class: 'XII-A', violations: 6, points: 32 },
  { id: 5, name: 'Diana Putri', class: 'XI-A', violations: 5, points: 28 },
])

const riskBadge = (pts) => pts >= 50 ? 'badge badge-danger' : pts >= 30 ? 'badge badge-warning' : 'badge badge-success'
const riskLabel = (pts) => pts >= 50 ? 'Tinggi' : pts >= 30 ? 'Sedang' : 'Rendah'
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1200px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.download-group { display: flex; gap: 8px; }
.filter-bar { display: flex; gap: 12px; align-items: flex-end; flex-wrap: wrap; padding: 16px; margin-bottom: 20px; }
.filter-group { display: flex; flex-direction: column; gap: 4px; }
.filter-label { font-size: 11px; font-weight: 600; color: #94a3b8; text-transform: uppercase; }
.filter-btn { margin-top: 0; }
.stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { display: flex; align-items: center; gap: 16px; padding: 16px 20px; }
.stat-icon { width: 48px; height: 48px; border-radius: 14px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.stat-label { font-size: 12px; color: #64748b; margin: 0; }
.stat-value { font-size: 24px; font-weight: 700; color: var(--text-primary, #1e293b); margin: 2px 0; }
.stat-change { font-size: 11px; margin: 0; }
.trend-up { color: #ef4444; }
.trend-down { color: #22c55e; }
.charts-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.chart-card { padding: 20px; }
.chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.chart-header h3 { font-size: 14px; font-weight: 600; margin: 0; }
.bar-chart { display: flex; align-items: flex-end; gap: 6px; height: 160px; padding-top: 20px; }
.bar-column { display: flex; flex-direction: column; align-items: center; flex: 1; gap: 4px; height: 100%; }
.bar-label-top { font-size: 10px; font-weight: 600; color: #64748b; height: 16px; }
.bar-wrap { flex: 1; display: flex; align-items: flex-end; width: 100%; }
.bar { width: 100%; border-radius: 4px 4px 0 0; transition: height 0.3s; min-height: 4px; }
.bar-label-bottom { font-size: 10px; color: #94a3b8; }
.category-dist { display: flex; flex-direction: column; gap: 12px; }
.dist-item { display: flex; align-items: center; gap: 10px; }
.dist-info { width: 120px; display: flex; flex-direction: column; }
.dist-name { font-size: 12px; font-weight: 500; }
.dist-count { font-size: 11px; color: #94a3b8; }
.dist-bar-bg { flex: 1; height: 8px; background: #f1f5f9; border-radius: 4px; overflow: hidden; }
.dist-bar-fill { height: 100%; border-radius: 4px; transition: width 0.5s; }
.dist-pct { font-size: 11px; font-weight: 600; color: #64748b; width: 32px; text-align: right; }
.section-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid #f1f5f9; }
.section-header h3 { font-size: 14px; font-weight: 600; margin: 0; }
table { width: 100%; border-collapse: collapse; }
th { padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #f1f5f9; }
td { padding: 14px 16px; font-size: 14px; border-bottom: 1px solid #f8fafc; vertical-align: middle; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }
.user-cell { display: flex; align-items: center; gap: 10px; }
.avatar { width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 600; font-size: 13px; flex-shrink: 0; }
.rank-badge { width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; }
.rank-1 { background: #fef3c7; color: #d97706; }
.rank-2 { background: #f1f5f9; color: #64748b; }
.rank-3 { background: #fef3c7; color: #92400e; }
.rank-4, .rank-5 { background: #f8fafc; color: #94a3b8; }
.form-input, .form-select { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; }
.form-input:focus, .form-select:focus { border-color: #2563eb; }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-outline { background: transparent; border: 1px solid #d1d5db; color: #374151; }
.btn-outline:hover { background: #f9fafb; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.badge-success { background: #dcfce7; color: #166534; }
.badge-danger { background: #fef2f2; color: #991b1b; }
.badge-warning { background: #fffbeb; color: #92400e; }
.badge-primary { background: #eff6ff; color: #1d4ed8; }
@media (max-width: 768px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
  .charts-row { grid-template-columns: 1fr; }
}
</style>
