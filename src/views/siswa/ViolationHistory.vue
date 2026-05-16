<script setup lang="ts">
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Siswa' }, { label: 'Riwayat Pelanggaran' }]

const violations = [
  { id: 1, date: '10/05/2026', type: 'Terlambat masuk sekolah', category: 'Kehadiran', points: 10, status: 'resolved' },
  { id: 2, date: '08/05/2026', type: 'Tidak mengerjakan PR', category: 'Akademik', points: 15, status: 'resolved' },
  { id: 3, date: '02/05/2026', type: 'Berpakaian tidak sesuai', category: 'Disiplin', points: 10, status: 'resolved' },
  { id: 4, date: '25/04/2026', type: 'Membolos pelajaran', category: 'Kehadiran', points: 30, status: 'processed' },
  { id: 5, date: '18/04/2026', type: 'Tidak mengerjakan PR', category: 'Akademik', points: 15, status: 'pending' },
]

const totalPoints = violations.reduce((s, v) => s + v.points, 0)
const totalCount = violations.length

function getCategoryBadge(cat: string) {
  const map: Record<string, string> = {
    'Kehadiran': 'badge-danger',
    'Akademik': 'badge-warning',
    'Disiplin': 'badge-primary',
    'Perilaku': 'badge-danger',
    'Fasilitas': 'badge-teal',
  }
  return map[cat] || 'badge-primary'
}

function getStatusBadge(status: string) {
  if (status === 'resolved') return 'badge-success'
  if (status === 'processed') return 'badge-primary'
  return 'badge-warning'
}

function getStatusLabel(status: string) {
  if (status === 'resolved') return 'Selesai'
  if (status === 'processed') return 'Diproses'
  return 'Pending'
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Riwayat Pelanggaran</h1>
        <p class="page-subtitle">Daftar pelanggaran yang pernah kamu lakukan beserta statusnya.</p>
      </div>

      <!-- Summary Cards -->
      <div class="summary-row">
        <div class="summary-card card">
          <div class="summary-icon red">
            <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" width="18" height="18">
              <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div>
            <div class="summary-val">{{ totalPoints }}</div>
            <div class="summary-lbl">Total Poin</div>
          </div>
        </div>
        <div class="summary-card card">
          <div class="summary-icon amber">
            <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" width="18" height="18">
              <path d="M4 6h16M4 10h16M4 14h16M4 18h16" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div>
            <div class="summary-val">{{ totalCount }}</div>
            <div class="summary-lbl">Total Pelanggaran</div>
          </div>
        </div>
        <div class="summary-card card">
          <div class="summary-icon green">
            <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" width="18" height="18">
              <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div>
            <div class="summary-val">{{ violations.filter(v => v.status === 'resolved').length }}</div>
            <div class="summary-lbl">Sudah Selesai</div>
          </div>
        </div>
      </div>

      <!-- Table -->
      <div class="card">
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Tanggal</th>
                <th>Jenis Pelanggaran</th>
                <th>Kategori</th>
                <th>Poin</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="v in violations" :key="v.id">
                <td>{{ v.date }}</td>
                <td class="type-cell">{{ v.type }}</td>
                <td>
                  <span :class="['badge', getCategoryBadge(v.category)]">{{ v.category }}</span>
                </td>
                <td>
                  <span class="points-chip" :style="{ color: v.points >= 25 ? 'var(--red-500)' : v.points >= 15 ? 'var(--amber-500)' : 'var(--green-500)' }">
                    +{{ v.points }}
                  </span>
                </td>
                <td>
                  <span :class="['badge', getStatusBadge(v.status)]">{{ getStatusLabel(v.status) }}</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="table-footer">
          <div class="total-row">
            <span class="total-label">Total Akumulasi Poin:</span>
            <span class="total-value" :style="{ color: totalPoints >= 50 ? 'var(--red-500)' : totalPoints >= 25 ? 'var(--amber-500)' : 'var(--green-500)' }">
              {{ totalPoints }} poin
            </span>
          </div>
        </div>
      </div>

      <!-- Info Box -->
      <div class="info-box">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18" style="flex-shrink:0;color:var(--primary-600)">
          <path d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <p>Jika ada data pelanggaran yang kamu rasa tidak akurat, segera hubungi Guru BK kamu untuk klarifikasi.</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-container { display: flex; flex-direction: column; min-height: 100vh; background: var(--bg-base); }
.page-content { padding: 1.5rem 2rem; flex: 1; }
.page-header { margin-bottom: 1.5rem; }

.summary-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
.summary-card { display: flex; align-items: center; gap: 0.875rem; }
.summary-icon { width: 42px; height: 42px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.summary-icon.red { background: var(--red-500); }
.summary-icon.amber { background: var(--amber-500); }
.summary-icon.green { background: var(--green-500); }
.summary-val { font-size: 1.5rem; font-weight: 700; color: var(--text-primary); line-height: 1; }
.summary-lbl { font-size: 0.75rem; color: var(--text-secondary); }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; margin-bottom: 1.25rem; }

.table-container { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
.data-table th { background: var(--bg-base); color: var(--text-secondary); font-weight: 600; text-align: left; padding: 0.75rem 1rem; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.04em; border-bottom: 1px solid var(--border-color); }
.data-table td { padding: 0.875rem 1rem; border-bottom: 1px solid var(--border-color); color: var(--text-primary); }
.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover { background: var(--bg-base); }
.type-cell { font-weight: 500; }
.points-chip { font-weight: 700; font-size: 0.9rem; }

.table-footer { padding-top: 0.75rem; border-top: 1px solid var(--border-color); margin-top: 0.5rem; }
.total-row { display: flex; justify-content: flex-end; align-items: center; gap: 0.75rem; }
.total-label { font-size: 0.875rem; color: var(--text-secondary); font-weight: 500; }
.total-value { font-size: 1rem; font-weight: 700; }

.info-box { display: flex; gap: 0.75rem; padding: 1rem 1.25rem; background: color-mix(in srgb, var(--primary-600) 8%, transparent); border: 1px solid color-mix(in srgb, var(--primary-600) 25%, transparent); border-radius: 10px; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5; }
</style>
