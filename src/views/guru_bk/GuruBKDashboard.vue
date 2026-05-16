<script setup lang="ts">
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Dashboard' }]

const stats = [
  { label: 'Total Siswa Bermasalah', value: 42, icon: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z', color: 'red', trend: '+3 minggu ini' },
  { label: 'Pelanggaran Hari Ini', value: 8, icon: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z', color: 'amber', trend: '+2 dari kemarin' },
  { label: 'Siswa Prioritas', value: 5, icon: 'M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z', color: 'red', trend: 'perlu tindakan segera' },
  { label: 'Konseling Aktif', value: 12, icon: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z', color: 'teal', trend: '3 jadwal hari ini' },
]

const weeklyData = [12, 8, 15, 6, 18, 4, 10]
const weekDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
const maxVal = Math.max(...weeklyData)

const priorityStudents = [
  { name: 'Ahmad Rizky', class: 'XI IPA 2', points: 95, risk: 'Berat' },
  { name: 'Budi Santoso', class: 'X IPS 1', points: 78, risk: 'Berat' },
  { name: 'Citra Dewi', class: 'XII IPA 1', points: 62, risk: 'Sedang' },
  { name: 'Dian Pratama', class: 'XI IPS 3', points: 55, risk: 'Sedang' },
  { name: 'Eko Wijaya', class: 'X IPA 3', points: 48, risk: 'Sedang' },
]

const recentActivities = [
  { student: 'Ahmad Rizky', action: 'Konseling Individual - Sesi 3', date: '15 Mei 2026', type: 'konseling' },
  { student: 'Budi Santoso', action: 'Pemanggilan Orang Tua', date: '14 Mei 2026', type: 'panggil' },
  { student: 'Citra Dewi', action: 'Konseling Kelompok - Motivasi Belajar', date: '13 Mei 2026', type: 'konseling' },
  { student: 'Dian Pratama', action: 'Pembinaan - Pertemuan Pertama', date: '12 Mei 2026', type: 'pembinaan' },
]

function getRiskClass(risk: string) {
  if (risk === 'Berat') return 'badge-danger'
  if (risk === 'Sedang') return 'badge-warning'
  return 'badge-success'
}

function getActivityIcon(type: string) {
  if (type === 'konseling') return '#14B8A6'
  if (type === 'panggil') return '#F59E0B'
  return '#3B82F6'
}

function getInitials(name: string) {
  return name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <div>
          <h1 class="page-title">Dashboard Guru BK</h1>
          <p class="page-subtitle">Selamat datang! Pantau kondisi siswa dan aktivitas bimbingan konseling.</p>
        </div>
      </div>

      <!-- Stats Grid -->
      <div class="stats-grid">
        <div v-for="stat in stats" :key="stat.label" class="stats-card" :data-color="stat.color">
          <div class="stats-icon" :style="{ background: stat.color === 'red' ? 'var(--red-500)' : stat.color === 'amber' ? 'var(--amber-500)' : stat.color === 'teal' ? 'var(--teal-500)' : 'var(--primary-600)' }">
            <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" width="22" height="22">
              <path :d="stat.icon" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
          </div>
          <div class="stats-body">
            <div class="stats-value">{{ stat.value }}</div>
            <div class="stats-label">{{ stat.label }}</div>
            <div class="stats-trend">{{ stat.trend }}</div>
          </div>
        </div>
      </div>

      <div class="dashboard-grid">
        <!-- Weekly Bar Chart -->
        <div class="card chart-card">
          <div class="card-header">
            <h3 class="card-title">Pelanggaran Mingguan</h3>
            <span class="badge badge-primary">Minggu Ini</span>
          </div>
          <div class="bar-chart">
            <div class="bar-chart-inner">
              <div
                v-for="(val, i) in weeklyData"
                :key="i"
                class="bar-col"
              >
                <div class="bar-label-top">{{ val }}</div>
                <div class="bar-wrap">
                  <div
                    class="bar"
                    :style="{ height: (val / maxVal * 100) + '%', background: val === maxVal ? 'var(--red-500)' : 'var(--primary-600)' }"
                  ></div>
                </div>
                <div class="bar-day">{{ weekDays[i] }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Priority Students -->
        <div class="card priority-card">
          <div class="card-header">
            <h3 class="card-title">Siswa Prioritas</h3>
            <span class="badge badge-danger">{{ priorityStudents.length }} Siswa</span>
          </div>
          <div class="priority-list">
            <div v-for="(s, i) in priorityStudents" :key="i" class="priority-item">
              <div class="priority-avatar">{{ getInitials(s.name) }}</div>
              <div class="priority-info">
                <div class="priority-name">{{ s.name }}</div>
                <div class="priority-class">{{ s.class }}</div>
              </div>
              <div class="priority-right">
                <div class="priority-points">{{ s.points }} poin</div>
                <span :class="['badge', getRiskClass(s.risk)]">{{ s.risk }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Aktivitas Konseling Terbaru</h3>
        </div>
        <div class="activity-list">
          <div v-for="(act, i) in recentActivities" :key="i" class="activity-item">
            <div class="activity-dot" :style="{ background: getActivityIcon(act.type) }"></div>
            <div class="activity-content">
              <div class="activity-student">{{ act.student }}</div>
              <div class="activity-action">{{ act.action }}</div>
            </div>
            <div class="activity-date">{{ act.date }}</div>
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
.stats-card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; display: flex; align-items: center; gap: 1rem; }
.stats-icon { width: 48px; height: 48px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.stats-value { font-size: 1.75rem; font-weight: 700; color: var(--text-primary); line-height: 1; }
.stats-label { font-size: 0.8rem; color: var(--text-secondary); margin-top: 2px; }
.stats-trend { font-size: 0.75rem; color: var(--text-muted); margin-top: 4px; }

.dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; }
.card-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; }
.card-title { font-size: 1rem; font-weight: 600; color: var(--text-primary); }

.bar-chart { padding: 0.5rem 0; }
.bar-chart-inner { display: flex; align-items: flex-end; gap: 8px; height: 160px; padding-bottom: 24px; position: relative; }
.bar-col { flex: 1; display: flex; flex-direction: column; align-items: center; height: 100%; }
.bar-label-top { font-size: 0.7rem; color: var(--text-muted); margin-bottom: 4px; }
.bar-wrap { flex: 1; width: 100%; display: flex; align-items: flex-end; }
.bar { width: 100%; border-radius: 4px 4px 0 0; transition: height 0.4s ease; min-height: 4px; }
.bar-day { font-size: 0.7rem; color: var(--text-secondary); margin-top: 6px; }

.priority-list { display: flex; flex-direction: column; gap: 0.75rem; }
.priority-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: var(--bg-base); border-radius: 8px; border: 1px solid var(--border-color); }
.priority-avatar { width: 38px; height: 38px; border-radius: 50%; background: var(--primary-600); color: white; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 700; flex-shrink: 0; }
.priority-info { flex: 1; min-width: 0; }
.priority-name { font-size: 0.9rem; font-weight: 600; color: var(--text-primary); }
.priority-class { font-size: 0.75rem; color: var(--text-secondary); }
.priority-right { display: flex; flex-direction: column; align-items: flex-end; gap: 4px; }
.priority-points { font-size: 0.85rem; font-weight: 600; color: var(--text-primary); }

.activity-list { display: flex; flex-direction: column; gap: 0.75rem; }
.activity-item { display: flex; align-items: center; gap: 1rem; padding: 0.75rem; border-radius: 8px; background: var(--bg-base); border: 1px solid var(--border-color); }
.activity-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
.activity-content { flex: 1; }
.activity-student { font-weight: 600; font-size: 0.9rem; color: var(--text-primary); }
.activity-action { font-size: 0.8rem; color: var(--text-secondary); }
.activity-date { font-size: 0.75rem; color: var(--text-muted); white-space: nowrap; }

@media (max-width: 1024px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
  .dashboard-grid { grid-template-columns: 1fr; }
}
</style>
