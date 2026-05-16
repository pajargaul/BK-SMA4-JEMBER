<script setup lang="ts">
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Siswa' }, { label: 'Riwayat Tindak Lanjut' }]

const followUps = [
  {
    id: 1,
    action: 'Konseling Pertama',
    date: '11/05/2026',
    status: 'done',
    counselor: 'Dra. Siti Rahayu, M.Pd.',
    notes: 'Pertemuan pertama berhasil dilakukan. Membahas latar belakang pelanggaran dan membuat kesepakatan perbaikan perilaku.',
    color: 'var(--teal-500)',
  },
  {
    id: 2,
    action: 'Pemanggilan Orang Tua',
    date: '22/05/2026',
    status: 'scheduled',
    counselor: 'Dra. Siti Rahayu, M.Pd.',
    notes: 'Orang tua dijadwalkan hadir ke sekolah untuk diskusi kondisi dan perkembangan siswa bersama Guru BK.',
    color: 'var(--amber-500)',
  },
  {
    id: 3,
    action: 'Monitoring Lanjutan',
    date: '01/06/2026',
    status: 'pending',
    counselor: 'Dra. Siti Rahayu, M.Pd.',
    notes: 'Pemantauan perilaku selama periode 2 minggu setelah konseling. Akan dievaluasi kembali pada akhir bulan.',
    color: 'var(--text-muted)',
  },
]

function getStatusBadge(status: string) {
  if (status === 'done') return 'badge-success'
  if (status === 'scheduled') return 'badge-warning'
  return 'badge'
}

function getStatusLabel(status: string) {
  if (status === 'done') return 'Selesai'
  if (status === 'scheduled') return 'Terjadwal'
  return 'Menunggu'
}

function getStatusIcon(status: string) {
  if (status === 'done') return '✓'
  if (status === 'scheduled') return '●'
  return '○'
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Riwayat Tindak Lanjut</h1>
        <p class="page-subtitle">Daftar tindak lanjut bimbingan konseling yang telah dan akan kamu jalani.</p>
      </div>

      <!-- Summary -->
      <div class="summary-row">
        <div class="summary-card card">
          <div class="summary-num">{{ followUps.length }}</div>
          <div class="summary-lbl">Total Tindak Lanjut</div>
        </div>
        <div class="summary-card card">
          <div class="summary-num green">{{ followUps.filter(f => f.status === 'done').length }}</div>
          <div class="summary-lbl">Selesai</div>
        </div>
        <div class="summary-card card">
          <div class="summary-num amber">{{ followUps.filter(f => f.status === 'scheduled').length }}</div>
          <div class="summary-lbl">Terjadwal</div>
        </div>
        <div class="summary-card card">
          <div class="summary-num muted">{{ followUps.filter(f => f.status === 'pending').length }}</div>
          <div class="summary-lbl">Menunggu</div>
        </div>
      </div>

      <!-- Timeline -->
      <div class="timeline-container">
        <div class="timeline">
          <div v-for="(item, i) in followUps" :key="item.id" class="timeline-item">
            <div v-if="i < followUps.length - 1" class="tl-connector" :style="{ background: item.status === 'done' ? item.color : 'var(--border-color)' }"></div>
            <div class="tl-dot-wrap">
              <div
                class="tl-dot"
                :style="{
                  background: item.status === 'done' ? item.color : item.status === 'scheduled' ? item.color : 'var(--bg-elevated)',
                  borderColor: item.color,
                  color: item.status !== 'pending' ? 'white' : item.color
                }"
              >
                <span class="tl-icon">{{ getStatusIcon(item.status) }}</span>
              </div>
            </div>
            <div class="tl-card card" :class="{ 'tl-done': item.status === 'done', 'tl-scheduled': item.status === 'scheduled' }">
              <div class="tl-header">
                <div class="tl-action">{{ item.action }}</div>
                <span :class="['badge', getStatusBadge(item.status)]">{{ getStatusLabel(item.status) }}</span>
              </div>
              <div class="tl-meta">
                <div class="tl-meta-item">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                  </svg>
                  {{ item.date }}
                </div>
                <div class="tl-meta-item">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13">
                    <path d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  {{ item.counselor }}
                </div>
              </div>
              <div class="tl-notes">{{ item.notes }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Info -->
      <div class="info-box">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18" style="flex-shrink:0;color:var(--primary-600)">
          <path d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <p>Tindak lanjut dibuat oleh Guru BK berdasarkan hasil evaluasi. Hadir tepat waktu di setiap sesi yang telah dijadwalkan ya!</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-container { display: flex; flex-direction: column; min-height: 100vh; background: var(--bg-base); }
.page-content { padding: 1.5rem 2rem; flex: 1; }
.page-header { margin-bottom: 1.5rem; }

.summary-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
.summary-card { text-align: center; padding: 1rem; }
.summary-num { font-size: 1.75rem; font-weight: 800; color: var(--text-primary); }
.summary-num.green { color: var(--green-500); }
.summary-num.amber { color: var(--amber-500); }
.summary-num.muted { color: var(--text-muted); }
.summary-lbl { font-size: 0.75rem; color: var(--text-secondary); margin-top: 2px; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; }

.timeline-container { margin-bottom: 1.5rem; }
.timeline { display: flex; flex-direction: column; gap: 0; padding-left: 3rem; position: relative; }
.timeline-item { position: relative; padding-bottom: 2rem; }
.timeline-item:last-child { padding-bottom: 0; }

.tl-connector { position: absolute; left: -2.2rem; top: 2.25rem; width: 2px; bottom: 0; }

.tl-dot-wrap { position: absolute; left: -2.75rem; top: 0.875rem; }
.tl-dot { width: 28px; height: 28px; border-radius: 50%; border: 2px solid; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 700; }
.tl-icon { line-height: 1; }

.tl-card { padding: 1.25rem; }
.tl-done { border-left: 3px solid var(--teal-500); }
.tl-scheduled { border-left: 3px solid var(--amber-500); }

.tl-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.625rem; }
.tl-action { font-weight: 700; font-size: 1rem; color: var(--text-primary); }
.tl-meta { display: flex; gap: 1.25rem; margin-bottom: 0.75rem; flex-wrap: wrap; }
.tl-meta-item { display: flex; align-items: center; gap: 0.35rem; font-size: 0.8rem; color: var(--text-secondary); }
.tl-notes { font-size: 0.85rem; color: var(--text-secondary); line-height: 1.6; background: var(--bg-base); padding: 0.75rem; border-radius: 8px; border: 1px solid var(--border-color); }

.info-box { display: flex; gap: 0.75rem; padding: 1rem 1.25rem; background: color-mix(in srgb, var(--primary-600) 8%, transparent); border: 1px solid color-mix(in srgb, var(--primary-600) 25%, transparent); border-radius: 10px; font-size: 0.85rem; color: var(--text-secondary); line-height: 1.5; }

@media (max-width: 600px) { .summary-row { grid-template-columns: repeat(2, 1fr); } }
</style>
