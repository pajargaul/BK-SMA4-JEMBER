<script setup lang="ts">
import { ref, onMounted } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'
import { supabase } from '../../lib/supabase'

const breadcrumbs = [{ label: 'Admin' }, { label: 'Dashboard' }]

const stats = ref([
  { label: 'Total Siswa', value: '...', icon: 'M12 14l9-5-9-5-9 5 9 5zm0 0l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14zm-4 6v-7.5l4-2.222', color: 'primary', change: '+5 bulan ini', up: true },
  { label: 'Total Guru BK', value: '...', icon: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z', color: 'teal', change: 'Aktif semua', up: true },
  { label: 'Total Pelanggaran', value: '...', icon: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2', color: 'amber', change: '+23 bulan ini', up: false },
  { label: 'Total User', value: '...', icon: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197', color: 'green', change: '+2 baru', up: true },
])

const recentActivity = ref([
  { name: 'Budi Santoso', class: 'XI IPA 2', action: 'Tidak hadir tanpa keterangan', time: '08:15', status: 'pending' },
  { name: 'Siti Aminah', class: 'X IPS 1', action: 'Tidak memakai seragam lengkap', time: '09:30', status: 'processed' },
  { name: 'Andi Prasetyo', class: 'XII IPA 1', action: 'Terlambat masuk kelas', time: '10:00', status: 'resolved' },
  { name: 'Citra Dewi', class: 'XI IPS 3', action: 'Membawa HP saat pelajaran', time: '11:20', status: 'pending' },
  { name: 'Reza Fahmi', class: 'X IPA 3', action: 'Pelanggaran berulang', time: '13:45', status: 'processed' },
])

const weeklyData = ref([38, 52, 41, 67, 48, 73, 55])
const catData = ref([
  { label: 'Kehadiran', value: 35, color: '#EF4444' },
  { label: 'Penampilan', value: 28, color: '#F59E0B' },
  { label: 'Perilaku', value: 20, color: '#8B5CF6' },
  { label: 'Akademik', value: 12, color: '#2563EB' },
  { label: 'Ketertiban', value: 5, color: '#14B8A6' },
])

const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
const maxVal = ref(Math.max(...weeklyData.value))

onMounted(async () => {
  const [{ count: students }, { count: teachers }, { count: violations }, { count: users }] = await Promise.all([
    supabase.from('students').select('*', { count: 'exact', head: true }),
    supabase.from('teachers').select('*', { count: 'exact', head: true }),
    supabase.from('violations').select('*', { count: 'exact', head: true }),
    supabase.from('profiles').select('*', { count: 'exact', head: true }),
  ])
  stats.value[0].value = String(students ?? 0)
  stats.value[1].value = String(teachers ?? 0)
  stats.value[2].value = String(violations ?? 0)
  stats.value[3].value = String(users ?? 0)
})
</script>

<template>
  <AppTopbar :breadcrumbs="breadcrumbs" />
  <div class="page-content animate-fade-in">
    <div class="page-header">
      <div>
        <h1 class="page-title">Dashboard Administrator</h1>
        <p class="page-subtitle">Selamat datang! Ini adalah ringkasan sistem monitoring saat ini.</p>
      </div>
      <div class="header-actions">
        <span class="live-indicator"><span class="live-dot"></span>Live</span>
        <button class="btn btn-primary btn-sm">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M12 10v6m0 0l-3-3m3 3l3-3M3 17v3a2 2 0 002 2h14a2 2 0 002-2v-3"/></svg>
          Export Laporan
        </button>
      </div>
    </div>

    <!-- Stats -->
    <div class="stats-grid" style="margin-bottom: 28px;">
      <div v-for="s in stats" :key="s.label" :class="['stats-card', s.color]">
        <div :class="['stats-icon', `bg-${s.color}`]">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="22" height="22">
            <path :d="s.icon"/>
          </svg>
        </div>
        <div class="stats-info">
          <div class="stats-label">{{ s.label }}</div>
          <div class="stats-value">{{ s.value }}</div>
          <div :class="['stats-change', s.up ? 'up' : 'down']">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="12" height="12">
              <path :d="s.up ? 'M5 15l7-7 7 7' : 'M19 9l-7 7-7-7'"/>
            </svg>
            {{ s.change }}
          </div>
        </div>
      </div>
    </div>

    <!-- Charts row -->
    <div class="charts-row">
      <!-- Bar chart -->
      <div class="card chart-card">
        <div class="chart-header">
          <div>
            <h3 class="chart-title">Tren Pelanggaran Mingguan</h3>
            <p class="chart-sub">7 hari terakhir</p>
          </div>
          <select class="form-input form-select" style="width: 120px; height: 36px; padding: 0 28px 0 12px; font-size: 12px;">
            <option>7 hari</option>
            <option>30 hari</option>
          </select>
        </div>
        <div class="bar-chart">
          <div v-for="(val, i) in weeklyData" :key="i" class="bar-group">
            <div class="bar-value">{{ val }}</div>
            <div class="bar-track">
              <div class="bar-fill" :style="{ height: (val / maxVal * 100) + '%' }"></div>
            </div>
            <div class="bar-label">{{ days[i] }}</div>
          </div>
        </div>
      </div>

      <!-- Category pie -->
      <div class="card chart-card">
        <div class="chart-header">
          <div>
            <h3 class="chart-title">Kategori Pelanggaran</h3>
            <p class="chart-sub">Distribusi bulan ini</p>
          </div>
        </div>
        <div class="pie-chart-wrapper">
          <div class="pie-visual">
            <svg viewBox="0 0 100 100" width="140" height="140">
              <circle cx="50" cy="50" r="40" fill="none" stroke="#E2E8F0" stroke-width="20"/>
              <circle cx="50" cy="50" r="40" fill="none" stroke="#EF4444" stroke-width="20" stroke-dasharray="88 165" stroke-dashoffset="0"/>
              <circle cx="50" cy="50" r="40" fill="none" stroke="#F59E0B" stroke-width="20" stroke-dasharray="70 165" stroke-dashoffset="-88"/>
              <circle cx="50" cy="50" r="40" fill="none" stroke="#8B5CF6" stroke-width="20" stroke-dasharray="50 165" stroke-dashoffset="-158"/>
              <circle cx="50" cy="50" r="40" fill="none" stroke="#2563EB" stroke-width="20" stroke-dasharray="30 165" stroke-dashoffset="-208"/>
              <circle cx="50" cy="50" r="40" fill="none" stroke="#14B8A6" stroke-width="20" stroke-dasharray="12 165" stroke-dashoffset="-238"/>
            </svg>
            <div class="pie-center"><span class="pie-total">100%</span></div>
          </div>
          <div class="pie-legend">
            <div v-for="c in catData" :key="c.label" class="legend-item">
              <span class="legend-dot" :style="{ background: c.color }"></span>
              <span class="legend-label">{{ c.label }}</span>
              <span class="legend-val">{{ c.value }}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Activity + Quick Actions -->
    <div class="bottom-row">
      <div class="card activity-card">
        <div class="card-header-row">
          <h3 class="card-title">Aktivitas Terbaru</h3>
          <button class="btn btn-ghost btn-sm">Lihat Semua</button>
        </div>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>Siswa</th>
                <th>Pelanggaran</th>
                <th>Waktu</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="a in recentActivity" :key="a.name">
                <td>
                  <div class="student-cell">
                    <div class="student-avatar">{{ a.name.charAt(0) }}</div>
                    <div>
                      <div class="font-semibold" style="font-size: 13px;">{{ a.name }}</div>
                      <div class="text-muted text-xs">{{ a.class }}</div>
                    </div>
                  </div>
                </td>
                <td style="font-size: 13px; color: var(--text-secondary);">{{ a.action }}</td>
                <td style="font-size: 13px; color: var(--text-muted);">{{ a.time }}</td>
                <td>
                  <span :class="['badge', a.status === 'resolved' ? 'badge-success' : a.status === 'processed' ? 'badge-warning' : 'badge-danger']">
                    {{ a.status === 'resolved' ? 'Selesai' : a.status === 'processed' ? 'Diproses' : 'Pending' }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="right-col">
        <div class="card quick-actions-card">
          <h3 class="card-title">Aksi Cepat</h3>
          <div class="quick-actions">
            <button v-for="qa in [
              { label: 'Tambah Siswa', icon: '👨‍🎓', color: 'primary' },
              { label: 'Input Pelanggaran', icon: '📝', color: 'amber' },
              { label: 'Generate Laporan', icon: '📊', color: 'teal' },
              { label: 'Evaluasi Fuzzy', icon: '🧠', color: 'green' },
            ]" :key="qa.label" :class="['quick-action-btn', qa.color]">
              <span class="qa-icon">{{ qa.icon }}</span>
              <span>{{ qa.label }}</span>
            </button>
          </div>
        </div>

        <div class="card system-info">
          <h3 class="card-title">Info Sistem</h3>
          <div class="info-rows">
            <div class="info-row">
              <span>Versi Sistem</span>
              <span class="badge badge-success">v2.1.0</span>
            </div>
            <div class="info-row">
              <span>Database</span>
              <span class="badge badge-success">Online</span>
            </div>
            <div class="info-row">
              <span>Fuzzy Engine</span>
              <span class="badge badge-success">Aktif</span>
            </div>
            <div class="info-row">
              <span>Last Backup</span>
              <span class="text-muted text-xs">Hari ini 06:00</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 24px; }
.header-actions { display: flex; align-items: center; gap: 12px; }
.live-indicator { display: flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; color: var(--green-500); }
.live-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--green-500); animation: pulse 2s infinite; }

.bg-primary { background: var(--primary-50); color: var(--primary-600); }
.bg-teal { background: var(--teal-50); color: var(--teal-600); }
.bg-amber { background: var(--amber-50); color: var(--amber-600); }
.bg-green { background: var(--green-50); color: var(--green-600); }
.dark .bg-primary { background: rgba(37,99,235,0.15); }
.dark .bg-teal { background: rgba(20,184,166,0.15); }
.dark .bg-amber { background: rgba(245,158,11,0.15); }
.dark .bg-green { background: rgba(34,197,94,0.15); }

.charts-row { display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px; margin-bottom: 20px; }
.chart-card { }
.chart-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 20px; }
.chart-title { font-size: 14px; font-weight: 700; }
.chart-sub { font-size: 12px; color: var(--text-muted); margin-top: 2px; }

.bar-chart { display: flex; gap: 8px; align-items: flex-end; height: 160px; padding-bottom: 4px; }
.bar-group { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 4px; height: 100%; }
.bar-value { font-size: 11px; font-weight: 600; color: var(--text-secondary); }
.bar-track { flex: 1; width: 100%; display: flex; align-items: flex-end; }
.bar-fill { width: 100%; border-radius: 4px 4px 0 0; background: linear-gradient(180deg, #2563EB, #60A5FA); min-height: 4px; transition: height 0.5s ease; }
.bar-label { font-size: 11px; color: var(--text-muted); }

.pie-chart-wrapper { display: flex; align-items: center; gap: 20px; }
.pie-visual { position: relative; display: flex; align-items: center; justify-content: center; }
.pie-center { position: absolute; text-align: center; }
.pie-total { font-size: 16px; font-weight: 800; color: var(--text-primary); }
.pie-legend { flex: 1; display: flex; flex-direction: column; gap: 8px; }
.legend-item { display: flex; align-items: center; gap: 8px; }
.legend-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
.legend-label { font-size: 12px; color: var(--text-secondary); flex: 1; }
.legend-val { font-size: 12px; font-weight: 600; color: var(--text-primary); }

.bottom-row { display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px; }
.card-header-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
.card-title { font-size: 14px; font-weight: 700; }
.student-cell { display: flex; align-items: center; gap: 10px; }
.student-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-400), var(--teal-400)); color: white; font-size: 13px; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }

.right-col { display: flex; flex-direction: column; gap: 20px; }
.quick-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 12px; }
.quick-action-btn { display: flex; flex-direction: column; align-items: center; gap: 8px; padding: 16px 8px; border-radius: 12px; border: 1.5px solid var(--border-color); background: none; cursor: pointer; font-size: 12px; font-weight: 600; color: var(--text-secondary); transition: all 0.2s; font-family: var(--font-primary); }
.quick-action-btn:hover { transform: translateY(-2px); }
.quick-action-btn.primary:hover { border-color: var(--primary-400); background: var(--primary-50); color: var(--primary-700); }
.quick-action-btn.amber:hover { border-color: var(--amber-400); background: var(--amber-50); color: var(--amber-700); }
.quick-action-btn.teal:hover { border-color: var(--teal-400); background: var(--teal-50); color: var(--teal-700); }
.quick-action-btn.green:hover { border-color: var(--green-400); background: var(--green-50); color: var(--green-700); }
.qa-icon { font-size: 22px; }

.info-rows { display: flex; flex-direction: column; gap: 10px; margin-top: 12px; }
.info-row { display: flex; align-items: center; justify-content: space-between; font-size: 13px; color: var(--text-secondary); }

@media (max-width: 1200px) {
  .charts-row, .bottom-row { grid-template-columns: 1fr; }
}
</style>
