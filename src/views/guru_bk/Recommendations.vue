<script setup lang="ts">
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Rekomendasi Tindakan' }]

const recommendations = [
  {
    level: 'Ringan',
    color: 'var(--green-500)',
    bgColor: 'color-mix(in srgb, var(--green-500) 10%, transparent)',
    borderColor: 'color-mix(in srgb, var(--green-500) 30%, transparent)',
    badge: 'badge-success',
    icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
    pointRange: '1–20 poin',
    actions: [
      { title: 'Bimbingan Kelas', desc: 'Pemberian arahan dan nasihat secara klasikal di dalam kelas bersama seluruh siswa.' },
      { title: 'Konseling Kelompok', desc: 'Sesi konseling bersama 4–8 siswa dengan permasalahan serupa untuk saling memberikan dukungan.' },
      { title: 'Pemberian Motivasi', desc: 'Pendampingan motivasional untuk meningkatkan kesadaran siswa akan dampak pelanggaran.' },
    ]
  },
  {
    level: 'Sedang',
    color: 'var(--amber-500)',
    bgColor: 'color-mix(in srgb, var(--amber-500) 10%, transparent)',
    borderColor: 'color-mix(in srgb, var(--amber-500) 30%, transparent)',
    badge: 'badge-warning',
    icon: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z',
    pointRange: '21–50 poin',
    actions: [
      { title: 'Konseling Individual', desc: 'Sesi konseling tatap muka satu-satu dengan siswa untuk menggali akar permasalahan.' },
      { title: 'Pemanggilan Orang Tua', desc: 'Mengundang orang tua/wali siswa ke sekolah untuk koordinasi tindakan pembinaan bersama.' },
      { title: 'Pembinaan Intensif', desc: 'Program pembinaan terjadwal selama 4–6 minggu dengan target perubahan perilaku terukur.' },
    ]
  },
  {
    level: 'Berat',
    color: 'var(--red-500)',
    bgColor: 'color-mix(in srgb, var(--red-500) 10%, transparent)',
    borderColor: 'color-mix(in srgb, var(--red-500) 30%, transparent)',
    badge: 'badge-danger',
    icon: 'M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636',
    pointRange: '51–100 poin',
    actions: [
      { title: 'Konseling Intensif', desc: 'Sesi konseling mendalam setiap minggu dengan penanganan khusus oleh Guru BK terlatih.' },
      { title: 'Kunjungan Rumah', desc: 'Kunjungan langsung ke kediaman siswa untuk memahami kondisi lingkungan dan membangun kerjasama orang tua.' },
      { title: 'Sidang Kasus', desc: 'Rapat khusus yang melibatkan Kepala Sekolah, Guru BK, Wali Kelas, dan orang tua siswa.' },
      { title: 'Pembinaan Khusus', desc: 'Program pembinaan ekstensif di luar jam pelajaran dengan pemantauan harian selama minimal 2 bulan.' },
    ]
  },
]

const followUpStudents = [
  { name: 'Ahmad Rizky', class: 'XI IPA 2', level: 'Berat', status: 'Konseling Intensif', due: '20/05/2026' },
  { name: 'Budi Santoso', class: 'X IPS 1', level: 'Berat', status: 'Kunjungan Rumah', due: '22/05/2026' },
  { name: 'Citra Dewi', class: 'XII IPA 1', level: 'Sedang', status: 'Konseling Individual', due: '18/05/2026' },
  { name: 'Dian Pratama', class: 'XI IPS 3', level: 'Sedang', status: 'Pemanggilan Ortu', due: '19/05/2026' },
  { name: 'Eko Wijaya', class: 'X IPA 3', level: 'Sedang', status: 'Pembinaan Intensif', due: '25/05/2026' },
]

function getInitials(name: string) {
  return name.split(' ').map((n: string) => n[0]).join('').slice(0, 2).toUpperCase()
}

function getLevelBadge(level: string) {
  if (level === 'Berat') return 'badge-danger'
  if (level === 'Sedang') return 'badge-warning'
  return 'badge-success'
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Rekomendasi Tindakan</h1>
        <p class="page-subtitle">Panduan tindakan penanganan berdasarkan tingkat keparahan pelanggaran siswa.</p>
      </div>

      <div class="rec-layout">
        <!-- Recommendation Cards -->
        <div class="rec-main">
          <div
            v-for="rec in recommendations"
            :key="rec.level"
            class="rec-card"
            :style="{ borderColor: rec.borderColor, background: rec.bgColor }"
          >
            <div class="rec-header">
              <div class="rec-icon" :style="{ background: rec.color }">
                <svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" width="20" height="20">
                  <path :d="rec.icon" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div class="rec-title-wrap">
                <div class="rec-title" :style="{ color: rec.color }">Tingkat {{ rec.level }}</div>
                <div class="rec-range">{{ rec.pointRange }}</div>
              </div>
              <span :class="['badge', rec.badge]">{{ rec.level }}</span>
            </div>

            <div class="rec-actions">
              <div v-for="(action, i) in rec.actions" :key="i" class="action-item">
                <div class="action-dot" :style="{ background: rec.color }"></div>
                <div class="action-body">
                  <div class="action-title">{{ action.title }}</div>
                  <div class="action-desc">{{ action.desc }}</div>
                </div>
              </div>
            </div>

            <div class="rec-footer">
              <button class="apply-btn" :style="{ color: rec.color, borderColor: rec.borderColor }">
                Terapkan Tindakan
              </button>
            </div>
          </div>
        </div>

        <!-- Follow-up Sidebar -->
        <div class="rec-sidebar">
          <div class="card">
            <div class="sidebar-header">
              <h3 class="sidebar-title">Siswa Butuh Tindak Lanjut</h3>
              <span class="badge badge-danger">{{ followUpStudents.length }}</span>
            </div>
            <div class="followup-list">
              <div v-for="(s, i) in followUpStudents" :key="i" class="followup-item">
                <div class="followup-avatar">{{ getInitials(s.name) }}</div>
                <div class="followup-info">
                  <div class="followup-name">{{ s.name }}</div>
                  <div class="followup-class">{{ s.class }}</div>
                  <div class="followup-action">{{ s.status }}</div>
                  <div class="followup-due">Tenggat: {{ s.due }}</div>
                </div>
                <span :class="['badge', getLevelBadge(s.level)]">{{ s.level }}</span>
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

.rec-layout { display: grid; grid-template-columns: 1fr 300px; gap: 1.5rem; align-items: start; }
.rec-main { display: flex; flex-direction: column; gap: 1.25rem; }

.rec-card { border: 1.5px solid; border-radius: 12px; padding: 1.25rem; }
.rec-header { display: flex; align-items: center; gap: 0.875rem; margin-bottom: 1.25rem; }
.rec-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.rec-title-wrap { flex: 1; }
.rec-title { font-size: 1.1rem; font-weight: 700; }
.rec-range { font-size: 0.75rem; color: var(--text-secondary); }

.rec-actions { display: flex; flex-direction: column; gap: 0.875rem; margin-bottom: 1.25rem; }
.action-item { display: flex; gap: 0.75rem; align-items: flex-start; }
.action-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; margin-top: 5px; }
.action-body {}
.action-title { font-weight: 600; font-size: 0.875rem; color: var(--text-primary); }
.action-desc { font-size: 0.8rem; color: var(--text-secondary); margin-top: 2px; line-height: 1.4; }

.rec-footer { border-top: 1px solid var(--border-color); padding-top: 0.875rem; }
.apply-btn { background: transparent; border: 1.5px solid; border-radius: 8px; padding: 0.4rem 1rem; font-weight: 600; font-size: 0.8rem; cursor: pointer; transition: all 0.2s; }
.apply-btn:hover { opacity: 0.8; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; }
.sidebar-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; }
.sidebar-title { font-size: 0.9rem; font-weight: 600; color: var(--text-primary); }

.followup-list { display: flex; flex-direction: column; gap: 0.875rem; }
.followup-item { display: flex; align-items: flex-start; gap: 0.75rem; padding: 0.75rem; background: var(--bg-base); border-radius: 8px; border: 1px solid var(--border-color); }
.followup-avatar { width: 36px; height: 36px; border-radius: 50%; background: var(--primary-600); color: white; font-size: 0.7rem; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.followup-info { flex: 1; min-width: 0; }
.followup-name { font-weight: 600; font-size: 0.85rem; color: var(--text-primary); }
.followup-class { font-size: 0.7rem; color: var(--text-secondary); }
.followup-action { font-size: 0.75rem; color: var(--primary-600); margin-top: 3px; font-weight: 500; }
.followup-due { font-size: 0.7rem; color: var(--text-muted); }

@media (max-width: 900px) {
  .rec-layout { grid-template-columns: 1fr; }
}
</style>
