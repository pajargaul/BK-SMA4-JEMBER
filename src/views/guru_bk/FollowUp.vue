<script setup lang="ts">
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Tindak Lanjut' }]

const showModal = ref(false)
const filterStudent = ref('')
const filterStatus = ref('')

const form = ref({
  student: '',
  actionType: '',
  scheduledDate: '',
  notes: '',
})

const students = ['Ahmad Rizky', 'Budi Santoso', 'Citra Dewi', 'Dian Pratama', 'Eko Wijaya']
const actionTypes = ['Konseling Pertama', 'Konseling Lanjutan', 'Pemanggilan Orang Tua', 'Kunjungan Rumah', 'Pembinaan', 'Sidang Kasus', 'Monitoring Lanjutan']

const timelineItems = ref([
  { id: 1, student: 'Ahmad Rizky', action: 'Konseling Pertama', date: '10/05/2026', status: 'done', notes: 'Siswa menunjukkan penyesalan. Disepakati jadwal konseling lanjutan setiap Senin.', color: 'var(--teal-500)' },
  { id: 2, student: 'Ahmad Rizky', action: 'Konseling Lanjutan', date: '17/05/2026', status: 'scheduled', notes: 'Jadwal konseling minggu ke-2. Fokus pada manajemen emosi.', color: 'var(--primary-600)' },
  { id: 3, student: 'Budi Santoso', action: 'Pemanggilan Orang Tua', date: '12/05/2026', status: 'done', notes: 'Orang tua hadir. Diskusi kondisi di rumah. Orang tua berkomitmen memantau lebih ketat.', color: 'var(--amber-500)' },
  { id: 4, student: 'Citra Dewi', action: 'Konseling Pertama', date: '13/05/2026', status: 'done', notes: 'Identifikasi masalah akademik. Siswa mengalami tekanan dari teman sebaya.', color: 'var(--teal-500)' },
  { id: 5, student: 'Dian Pratama', action: 'Pembinaan', date: '14/05/2026', status: 'done', notes: 'Pembinaan sesi 1 dari 4. Pembahasan aturan tata tertib dan konsekuensinya.', color: 'var(--primary-600)' },
  { id: 6, student: 'Eko Wijaya', action: 'Monitoring Lanjutan', date: '20/05/2026', status: 'pending', notes: 'Monitoring perkembangan setelah konseling awal.', color: 'var(--text-muted)' },
])

const filtered = computed(() => {
  return timelineItems.value.filter(item => {
    const matchStudent = !filterStudent.value || item.student === filterStudent.value
    const matchStatus = !filterStatus.value || item.status === filterStatus.value
    return matchStudent && matchStatus
  })
})

function getStatusBadge(status: string) {
  if (status === 'done') return 'badge-success'
  if (status === 'scheduled') return 'badge-primary'
  return 'badge-warning'
}

function getStatusLabel(status: string) {
  if (status === 'done') return 'Selesai'
  if (status === 'scheduled') return 'Terjadwal'
  return 'Menunggu'
}

function openModal() {
  form.value = { student: '', actionType: '', scheduledDate: '', notes: '' }
  showModal.value = true
}

function saveFollowUp() {
  if (!form.value.student || !form.value.actionType || !form.value.scheduledDate) return
  timelineItems.value.unshift({
    id: Date.now(),
    student: form.value.student,
    action: form.value.actionType,
    date: form.value.scheduledDate.split('-').reverse().join('/'),
    status: 'scheduled',
    notes: form.value.notes,
    color: 'var(--primary-600)',
  })
  showModal.value = false
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header-row">
        <div>
          <h1 class="page-title">Tindak Lanjut</h1>
          <p class="page-subtitle">Pantau dan kelola semua tindak lanjut bimbingan konseling siswa.</p>
        </div>
        <button class="btn btn-primary" @click="openModal">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
            <path d="M12 4v16m8-8H4" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Tambah Tindak Lanjut
        </button>
      </div>

      <!-- Filters -->
      <div class="card filter-bar">
        <div class="filter-group">
          <label class="form-label">Filter Siswa</label>
          <select v-model="filterStudent" class="form-select">
            <option value="">Semua Siswa</option>
            <option v-for="s in students" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>
        <div class="filter-group">
          <label class="form-label">Status</label>
          <select v-model="filterStatus" class="form-select">
            <option value="">Semua Status</option>
            <option value="done">Selesai</option>
            <option value="scheduled">Terjadwal</option>
            <option value="pending">Menunggu</option>
          </select>
        </div>
        <div class="filter-count" style="margin-left:auto;align-self:flex-end">
          <span class="badge badge-primary">{{ filtered.length }} item</span>
        </div>
      </div>

      <!-- Timeline -->
      <div class="timeline-wrap">
        <div class="timeline">
          <div v-for="item in filtered" :key="item.id" class="timeline-item">
            <div class="timeline-line"></div>
            <div class="timeline-dot" :style="{ background: item.color, borderColor: item.color }"></div>
            <div class="timeline-card card">
              <div class="tl-header">
                <div class="tl-action">{{ item.action }}</div>
                <span :class="['badge', getStatusBadge(item.status)]">{{ getStatusLabel(item.status) }}</span>
              </div>
              <div class="tl-meta">
                <span class="tl-student">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="12" height="12">
                    <path d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  {{ item.student }}
                </span>
                <span class="tl-date">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="12" height="12">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                  </svg>
                  {{ item.date }}
                </span>
              </div>
              <div class="tl-notes" v-if="item.notes">{{ item.notes }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <Teleport to="body">
      <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
        <div class="modal-box">
          <div class="modal-header">
            <h3 class="modal-title">Tambah Tindak Lanjut</h3>
            <button class="modal-close" @click="showModal = false">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
                <path d="M6 18L18 6M6 6l12 12" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label">Siswa <span class="required">*</span></label>
              <select v-model="form.student" class="form-select">
                <option value="">-- Pilih Siswa --</option>
                <option v-for="s in students" :key="s" :value="s">{{ s }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Jenis Tindakan <span class="required">*</span></label>
              <select v-model="form.actionType" class="form-select">
                <option value="">-- Pilih Tindakan --</option>
                <option v-for="a in actionTypes" :key="a" :value="a">{{ a }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Tanggal Dijadwalkan <span class="required">*</span></label>
              <input v-model="form.scheduledDate" type="date" class="form-input" />
            </div>
            <div class="form-group">
              <label class="form-label">Catatan</label>
              <textarea v-model="form.notes" class="form-textarea" rows="3" placeholder="Catatan tambahan..."></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-outline" @click="showModal = false">Batal</button>
            <button class="btn btn-primary" @click="saveFollowUp">Simpan</button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
.page-container { display: flex; flex-direction: column; min-height: 100vh; background: var(--bg-base); }
.page-content { padding: 1.5rem 2rem; flex: 1; }
.page-header-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; }
.filter-bar { display: flex; gap: 1rem; flex-wrap: wrap; padding: 1rem 1.25rem; margin-bottom: 1.5rem; align-items: flex-end; }
.filter-group { display: flex; flex-direction: column; gap: 0.25rem; min-width: 160px; }

.timeline-wrap { position: relative; }
.timeline { display: flex; flex-direction: column; gap: 0; padding-left: 2rem; }
.timeline-item { position: relative; padding-bottom: 1.5rem; }
.timeline-item:last-child { padding-bottom: 0; }
.timeline-item:last-child .timeline-line { display: none; }
.timeline-line { position: absolute; left: -1.375rem; top: 20px; bottom: 0; width: 2px; background: var(--border-color); }
.timeline-dot { position: absolute; left: -1.625rem; top: 8px; width: 12px; height: 12px; border-radius: 50%; border: 2px solid; background: white; z-index: 1; }
.timeline-card { padding: 1rem 1.25rem; }

.tl-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; }
.tl-action { font-weight: 700; font-size: 0.95rem; color: var(--text-primary); }
.tl-meta { display: flex; gap: 1.25rem; margin-bottom: 0.5rem; }
.tl-student, .tl-date { display: flex; align-items: center; gap: 0.3rem; font-size: 0.8rem; color: var(--text-secondary); }
.tl-notes { font-size: 0.82rem; color: var(--text-secondary); line-height: 1.5; background: var(--bg-base); padding: 0.6rem 0.75rem; border-radius: 6px; border: 1px solid var(--border-color); }

.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: var(--bg-surface); border-radius: 12px; width: 480px; max-width: 95vw; overflow: hidden; }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border-color); }
.modal-title { font-size: 1rem; font-weight: 700; color: var(--text-primary); }
.modal-close { background: none; border: none; cursor: pointer; color: var(--text-muted); display: flex; align-items: center; justify-content: center; }
.modal-body { padding: 1.5rem; display: flex; flex-direction: column; gap: 0.75rem; }
.modal-footer { display: flex; gap: 0.75rem; justify-content: flex-end; padding: 1rem 1.5rem; border-top: 1px solid var(--border-color); }

.required { color: var(--red-500); }
.btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.875rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: var(--primary-600); color: white; }
.btn-outline { background: transparent; color: var(--text-primary); border: 1.5px solid var(--border-color); }
</style>
