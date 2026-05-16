<script setup lang="ts">
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Laporan' }]

const selectedMonth = ref('2026-05')
const selectedClass = ref('')

const stats = [
  { label: 'Pelanggaran Bulan Ini', value: 34, icon: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z', color: 'var(--red-500)' },
  { label: 'Siswa Dipantau', value: 42, icon: 'M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z', color: 'var(--primary-600)' },
  { label: 'Kasus Selesai', value: 18, icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z', color: 'var(--green-500)' },
]

const reportData = [
  { class: 'X IPA 3', violations: 6, students: 3, resolved: 4, pending: 2 },
  { class: 'X IPS 1', violations: 8, students: 4, resolved: 5, pending: 3 },
  { class: 'XI IPA 1', violations: 4, students: 2, resolved: 4, pending: 0 },
  { class: 'XI IPA 2', violations: 9, students: 5, resolved: 3, pending: 6 },
  { class: 'XI IPS 3', violations: 5, students: 3, resolved: 3, pending: 2 },
  { class: 'XII IPA 1', violations: 3, students: 2, resolved: 2, pending: 1 },
  { class: 'XII IPS 2', violations: 7, students: 4, resolved: 4, pending: 3 },
]

const topViolations = [
  { type: 'Terlambat masuk sekolah', count: 12, pct: 35 },
  { type: 'Tidak mengerjakan PR', count: 8, pct: 24 },
  { type: 'Membolos pelajaran', count: 6, pct: 18 },
  { type: 'Berpakaian tidak sesuai', count: 4, pct: 12 },
  { type: 'Lainnya', count: 4, pct: 11 },
]
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header-row">
        <div>
          <h1 class="page-title">Laporan</h1>
          <p class="page-subtitle">Laporan pelanggaran siswa yang menjadi tanggung jawab Guru BK.</p>
        </div>
        <div class="export-buttons">
          <button class="btn btn-outline">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
              <path d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Export PDF
          </button>
          <button class="btn btn-primary">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
              <path d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Export Excel
          </button>
        </div>
      </div>

      <!-- Filters -->
      <div class="card filter-bar">
        <div class="filter-group">
          <label class="form-label">Bulan/Tahun</label>
          <input v-model="selectedMonth" type="month" class="form-input" />
        </div>
        <div class="filter-group">
          <label class="form-label">Kelas</label>
          <select v-model="selectedClass" class="form-select">
            <option value="">Semua Kelas</option>
            <option v-for="r in reportData" :key="r.class" :value="r.class">{{ r.class }}</option>
          </select>
        </div>
      </div>

      <!-- Stats -->
      <div class="stats-row">
        <div v-for="stat in stats" :key="stat.label" class="stat-card card">
          <div class="stat-icon" :style="{ background: stat.color }">
            <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" width="20" height="20">
              <path :d="stat.icon" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>
      </div>

      <div class="report-grid">
        <!-- Class Report Table -->
        <div class="card">
          <h3 class="section-title">Laporan Per Kelas</h3>
          <div class="table-container">
            <table class="data-table">
              <thead>
                <tr>
                  <th>Kelas</th>
                  <th>Total Pelanggaran</th>
                  <th>Siswa Bermasalah</th>
                  <th>Selesai</th>
                  <th>Pending</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="r in reportData" :key="r.class">
                  <td class="bold-cell">{{ r.class }}</td>
                  <td>{{ r.violations }}</td>
                  <td>{{ r.students }}</td>
                  <td><span class="badge badge-success">{{ r.resolved }}</span></td>
                  <td><span class="badge badge-warning">{{ r.pending }}</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Top Violation Types -->
        <div class="card">
          <h3 class="section-title">Jenis Pelanggaran Terbanyak</h3>
          <div class="violation-bars">
            <div v-for="v in topViolations" :key="v.type" class="vbar-item">
              <div class="vbar-header">
                <span class="vbar-label">{{ v.type }}</span>
                <span class="vbar-count">{{ v.count }}x</span>
              </div>
              <div class="progress">
                <div class="progress-bar" :style="{ width: v.pct + '%', background: v.pct > 30 ? 'var(--red-500)' : v.pct > 20 ? 'var(--amber-500)' : 'var(--primary-600)' }"></div>
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
.page-header-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem; }
.export-buttons { display: flex; gap: 0.75rem; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; }

.filter-bar { display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 1.25rem; }
.filter-group { display: flex; flex-direction: column; gap: 0.25rem; min-width: 160px; }

.stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
.stat-card { display: flex; align-items: center; gap: 1rem; }
.stat-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.stat-value { font-size: 1.75rem; font-weight: 700; color: var(--text-primary); line-height: 1; }
.stat-label { font-size: 0.8rem; color: var(--text-secondary); margin-top: 2px; }

.report-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
.section-title { font-size: 0.95rem; font-weight: 600; color: var(--text-primary); margin-bottom: 1rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-color); }

.table-container { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
.data-table th { background: var(--bg-base); color: var(--text-secondary); font-weight: 600; text-align: left; padding: 0.65rem 0.875rem; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.04em; border-bottom: 1px solid var(--border-color); }
.data-table td { padding: 0.75rem 0.875rem; border-bottom: 1px solid var(--border-color); color: var(--text-primary); }
.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover { background: var(--bg-base); }
.bold-cell { font-weight: 600; }

.violation-bars { display: flex; flex-direction: column; gap: 1rem; }
.vbar-item {}
.vbar-header { display: flex; justify-content: space-between; margin-bottom: 0.4rem; }
.vbar-label { font-size: 0.85rem; color: var(--text-primary); }
.vbar-count { font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); }
.progress { background: var(--bg-elevated); border-radius: 999px; height: 8px; overflow: hidden; }
.progress-bar { height: 100%; border-radius: 999px; transition: width 0.5s ease; }

.btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.875rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: var(--primary-600); color: white; }
.btn-outline { background: transparent; color: var(--text-primary); border: 1.5px solid var(--border-color); }

@media (max-width: 900px) {
  .report-grid { grid-template-columns: 1fr; }
  .stats-row { grid-template-columns: 1fr; }
}
</style>
