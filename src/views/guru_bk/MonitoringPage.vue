<script setup lang="ts">
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Monitoring Siswa' }]

const searchQuery = ref('')
const classFilter = ref('')
const riskFilter = ref('')

const students = ref([
  { id: 1, name: 'Ahmad Rizky', class: 'XI IPA 2', points: 95, risk: 'Tinggi', trend: 'worsening', violations: 12 },
  { id: 2, name: 'Budi Santoso', class: 'X IPS 1', points: 78, risk: 'Tinggi', trend: 'stable', violations: 9 },
  { id: 3, name: 'Citra Dewi', class: 'XII IPA 1', points: 55, risk: 'Sedang', trend: 'improving', violations: 6 },
  { id: 4, name: 'Dian Pratama', class: 'XI IPS 3', points: 48, risk: 'Sedang', trend: 'worsening', violations: 5 },
  { id: 5, name: 'Eko Wijaya', class: 'X IPA 3', points: 32, risk: 'Sedang', trend: 'improving', violations: 4 },
  { id: 6, name: 'Fajar Nugroho', class: 'XII IPS 2', points: 15, risk: 'Rendah', trend: 'stable', violations: 2 },
])

const classes = ['X IPA 3', 'X IPS 1', 'XI IPA 1', 'XI IPA 2', 'XI IPS 3', 'XII IPA 1', 'XII IPS 2']

const filtered = computed(() => {
  return students.value.filter(s => {
    const matchSearch = !searchQuery.value || s.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchClass = !classFilter.value || s.class === classFilter.value
    const matchRisk = !riskFilter.value || s.risk === riskFilter.value
    return matchSearch && matchClass && matchRisk
  })
})

function getRingColor(risk: string) {
  if (risk === 'Tinggi') return 'var(--red-500)'
  if (risk === 'Sedang') return 'var(--amber-500)'
  return 'var(--green-500)'
}

function getBarColor(points: number) {
  if (points > 75) return 'var(--red-500)'
  if (points > 40) return 'var(--amber-500)'
  return 'var(--green-500)'
}

function getRiskBadge(risk: string) {
  if (risk === 'Tinggi') return 'badge-danger'
  if (risk === 'Sedang') return 'badge-warning'
  return 'badge-success'
}

function getInitials(name: string) {
  return name.split(' ').map((n: string) => n[0]).join('').slice(0, 2).toUpperCase()
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Monitoring Siswa</h1>
        <p class="page-subtitle">Pantau kondisi dan tingkat risiko pelanggaran seluruh siswa binaan.</p>
      </div>

      <!-- Filter Bar -->
      <div class="filter-bar card">
        <div class="filter-search">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16" class="filter-icon">
            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
          </svg>
          <input v-model="searchQuery" class="form-input filter-input" placeholder="Cari siswa..." />
        </div>
        <select v-model="classFilter" class="form-select filter-select">
          <option value="">Semua Kelas</option>
          <option v-for="c in classes" :key="c" :value="c">{{ c }}</option>
        </select>
        <select v-model="riskFilter" class="form-select filter-select">
          <option value="">Semua Tingkat Risiko</option>
          <option value="Rendah">Rendah</option>
          <option value="Sedang">Sedang</option>
          <option value="Tinggi">Tinggi</option>
        </select>
        <div class="filter-count">
          <span class="badge badge-primary">{{ filtered.length }} siswa</span>
        </div>
      </div>

      <!-- Student Cards Grid -->
      <div class="students-grid">
        <div v-for="s in filtered" :key="s.id" class="student-card card">
          <div class="card-top">
            <div class="avatar-wrap" :style="{ '--ring-color': getRingColor(s.risk) }">
              <div class="avatar-ring">
                <div class="avatar">{{ getInitials(s.name) }}</div>
              </div>
            </div>
            <div class="student-info">
              <div class="student-name">{{ s.name }}</div>
              <div class="student-class">{{ s.class }}</div>
            </div>
            <span :class="['badge', getRiskBadge(s.risk)]">{{ s.risk }}</span>
          </div>

          <div class="card-body">
            <div class="points-row">
              <span class="points-label">Total Poin Pelanggaran</span>
              <span class="points-value" :style="{ color: getBarColor(s.points) }">{{ s.points }}</span>
            </div>
            <div class="progress">
              <div
                class="progress-bar"
                :style="{ width: Math.min(s.points, 100) + '%', background: getBarColor(s.points) }"
              ></div>
            </div>

            <div class="stats-row">
              <div class="stat-item">
                <div class="stat-num">{{ s.violations }}</div>
                <div class="stat-lbl">Pelanggaran</div>
              </div>
              <div class="stat-item trend-item">
                <div :class="['trend-icon', s.trend === 'improving' ? 'trend-up' : s.trend === 'worsening' ? 'trend-down' : 'trend-stable']">
                  <svg v-if="s.trend === 'improving'" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="16" height="16">
                    <path d="M5 15l7-7 7 7" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  <svg v-else-if="s.trend === 'worsening'" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="16" height="16">
                    <path d="M19 9l-7 7-7-7" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" width="16" height="16">
                    <path d="M5 12h14" stroke-linecap="round"/>
                  </svg>
                </div>
                <div class="stat-lbl">
                  <span v-if="s.trend === 'improving'">Membaik</span>
                  <span v-else-if="s.trend === 'worsening'">Memburuk</span>
                  <span v-else>Stabil</span>
                </div>
              </div>
            </div>
          </div>

          <div class="card-footer">
            <button class="btn btn-outline btn-sm detail-btn">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14">
                <path d="M15 12a3 3 0 11-6 0 3 3 0 016 0z M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Lihat Detail
            </button>
          </div>
        </div>
      </div>

      <div v-if="filtered.length === 0" class="empty-state">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="48" height="48" class="empty-icon">
          <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
        </svg>
        <p>Tidak ada siswa yang sesuai filter.</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-container { display: flex; flex-direction: column; min-height: 100vh; background: var(--bg-base); }
.page-content { padding: 1.5rem 2rem; flex: 1; }
.page-header { margin-bottom: 1.5rem; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; }

.filter-bar { display: flex; align-items: center; gap: 1rem; padding: 1rem 1.25rem; margin-bottom: 1.5rem; flex-wrap: wrap; }
.filter-search { position: relative; flex: 1; min-width: 200px; }
.filter-icon { position: absolute; left: 0.75rem; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
.filter-input { padding-left: 2.25rem; }
.filter-select { min-width: 160px; }
.filter-count { margin-left: auto; }

.students-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.25rem; }

.student-card { padding: 1.25rem; display: flex; flex-direction: column; gap: 1rem; transition: box-shadow 0.2s; }
.student-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }

.card-top { display: flex; align-items: center; gap: 0.75rem; }
.avatar-ring { width: 48px; height: 48px; border-radius: 50%; padding: 3px; background: var(--ring-color, var(--primary-600)); }
.avatar { width: 42px; height: 42px; border-radius: 50%; background: var(--bg-elevated); color: var(--text-primary); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; }
.student-info { flex: 1; min-width: 0; }
.student-name { font-weight: 600; font-size: 0.9rem; color: var(--text-primary); }
.student-class { font-size: 0.75rem; color: var(--text-secondary); }

.card-body { display: flex; flex-direction: column; gap: 0.5rem; }
.points-row { display: flex; justify-content: space-between; align-items: center; }
.points-label { font-size: 0.75rem; color: var(--text-secondary); }
.points-value { font-size: 0.9rem; font-weight: 700; }

.progress { background: var(--bg-elevated); border-radius: 999px; height: 6px; overflow: hidden; }
.progress-bar { height: 100%; border-radius: 999px; transition: width 0.5s ease; }

.stats-row { display: flex; gap: 1rem; margin-top: 0.25rem; }
.stat-item { display: flex; align-items: center; gap: 0.35rem; }
.trend-item { margin-left: auto; }
.stat-num { font-weight: 700; font-size: 0.9rem; color: var(--text-primary); }
.stat-lbl { font-size: 0.75rem; color: var(--text-secondary); }
.trend-icon { display: flex; align-items: center; }
.trend-up { color: var(--green-500); }
.trend-down { color: var(--red-500); }
.trend-stable { color: var(--text-muted); }

.card-footer { padding-top: 0.75rem; border-top: 1px solid var(--border-color); }
.detail-btn { width: 100%; justify-content: center; display: flex; align-items: center; gap: 0.4rem; padding: 0.5rem; border-radius: 8px; font-size: 0.8rem; font-weight: 600; cursor: pointer; background: transparent; border: 1.5px solid var(--border-color); color: var(--text-primary); transition: all 0.15s; }
.detail-btn:hover { border-color: var(--primary-600); color: var(--primary-600); }

.empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
.empty-icon { margin: 0 auto 1rem; display: block; opacity: 0.4; }

@media (max-width: 1100px) { .students-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 700px) { .students-grid { grid-template-columns: 1fr; } }
</style>
