<script setup lang="ts">
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Riwayat Pelanggaran' }]

const searchStudent = ref('')
const dateFrom = ref('')
const dateTo = ref('')
const categoryFilter = ref('')
const currentPage = ref(1)
const perPage = 5

const violations = ref([
  { id: 1, date: '15/05/2026', student: 'Ahmad Rizky', class: 'XI IPA 2', type: 'Membolos pelajaran', category: 'Kehadiran', points: 30, status: 'processed' },
  { id: 2, date: '15/05/2026', student: 'Budi Santoso', class: 'X IPS 1', type: 'Terlambat masuk sekolah', category: 'Kehadiran', points: 10, status: 'resolved' },
  { id: 3, date: '14/05/2026', student: 'Citra Dewi', class: 'XII IPA 1', type: 'Tidak mengerjakan PR', category: 'Akademik', points: 15, status: 'pending' },
  { id: 4, date: '13/05/2026', student: 'Dian Pratama', class: 'XI IPS 3', type: 'Berkelahi', category: 'Perilaku', points: 75, status: 'processed' },
  { id: 5, date: '12/05/2026', student: 'Eko Wijaya', class: 'X IPA 3', type: 'Berpakaian tidak sesuai', category: 'Disiplin', points: 10, status: 'resolved' },
  { id: 6, date: '11/05/2026', student: 'Fajar Nugroho', class: 'XII IPS 2', type: 'Membawa HP saat ujian', category: 'Akademik', points: 50, status: 'pending' },
  { id: 7, date: '10/05/2026', student: 'Gita Sari', class: 'XI IPA 1', type: 'Vandalism', category: 'Fasilitas', points: 60, status: 'processed' },
  { id: 8, date: '09/05/2026', student: 'Ahmad Rizky', class: 'XI IPA 2', type: 'Terlambat masuk sekolah', category: 'Kehadiran', points: 10, status: 'resolved' },
  { id: 9, date: '08/05/2026', student: 'Budi Santoso', class: 'X IPS 1', type: 'Tidak mengerjakan PR', category: 'Akademik', points: 15, status: 'resolved' },
  { id: 10, date: '07/05/2026', student: 'Dian Pratama', class: 'XI IPS 3', type: 'Membolos pelajaran', category: 'Kehadiran', points: 30, status: 'pending' },
])

const categories = ['Kehadiran', 'Akademik', 'Perilaku', 'Disiplin', 'Fasilitas']

const filtered = computed(() => {
  return violations.value.filter(v => {
    const matchSearch = !searchStudent.value || v.student.toLowerCase().includes(searchStudent.value.toLowerCase())
    const matchCat = !categoryFilter.value || v.category === categoryFilter.value
    return matchSearch && matchCat
  })
})

const totalPages = computed(() => Math.ceil(filtered.value.length / perPage))
const paginated = computed(() => {
  const start = (currentPage.value - 1) * perPage
  return filtered.value.slice(start, start + perPage)
})

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

function prevPage() { if (currentPage.value > 1) currentPage.value-- }
function nextPage() { if (currentPage.value < totalPages.value) currentPage.value++ }
function goPage(n: number) { currentPage.value = n }
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Riwayat Pelanggaran</h1>
        <p class="page-subtitle">Rekap seluruh pelanggaran yang telah dicatat beserta statusnya.</p>
      </div>

      <!-- Filters -->
      <div class="card filter-bar">
        <div class="filter-group">
          <label class="form-label">Dari Tanggal</label>
          <input v-model="dateFrom" type="date" class="form-input" />
        </div>
        <div class="filter-group">
          <label class="form-label">Sampai Tanggal</label>
          <input v-model="dateTo" type="date" class="form-input" />
        </div>
        <div class="filter-group">
          <label class="form-label">Cari Siswa</label>
          <input v-model="searchStudent" class="form-input" placeholder="Nama siswa..." />
        </div>
        <div class="filter-group">
          <label class="form-label">Kategori</label>
          <select v-model="categoryFilter" class="form-select">
            <option value="">Semua Kategori</option>
            <option v-for="c in categories" :key="c" :value="c">{{ c }}</option>
          </select>
        </div>
      </div>

      <!-- Table -->
      <div class="card">
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Tanggal</th>
                <th>Nama Siswa</th>
                <th>Kelas</th>
                <th>Jenis Pelanggaran</th>
                <th>Kategori</th>
                <th>Poin</th>
                <th>Status</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="v in paginated" :key="v.id">
                <td>{{ v.date }}</td>
                <td class="student-cell">{{ v.student }}</td>
                <td>{{ v.class }}</td>
                <td>{{ v.type }}</td>
                <td>
                  <span class="badge badge-primary">{{ v.category }}</span>
                </td>
                <td>
                  <span class="points-chip" :style="{ color: v.points >= 50 ? 'var(--red-500)' : v.points >= 20 ? 'var(--amber-500)' : 'var(--green-500)' }">
                    {{ v.points }}
                  </span>
                </td>
                <td>
                  <span :class="['badge', getStatusBadge(v.status)]">{{ getStatusLabel(v.status) }}</span>
                </td>
                <td>
                  <div class="actions">
                    <button class="icon-action" title="Lihat Detail">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
                        <path d="M15 12a3 3 0 11-6 0 3 3 0 016 0z M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                    <button class="icon-action edit" title="Edit">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
                        <path d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="pagination">
          <div class="pagination-info">
            Menampilkan {{ ((currentPage - 1) * perPage) + 1 }}–{{ Math.min(currentPage * perPage, filtered.length) }} dari {{ filtered.length }} data
          </div>
          <div class="pagination-controls">
            <button class="page-btn" :disabled="currentPage === 1" @click="prevPage">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M15 18l-6-6 6-6" stroke-linecap="round" stroke-linejoin="round"/></svg>
            </button>
            <button
              v-for="n in totalPages"
              :key="n"
              :class="['page-btn', { active: n === currentPage }]"
              @click="goPage(n)"
            >{{ n }}</button>
            <button class="page-btn" :disabled="currentPage === totalPages" @click="nextPage">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M9 18l6-6-6-6" stroke-linecap="round" stroke-linejoin="round"/></svg>
            </button>
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

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.25rem; margin-bottom: 1.25rem; }

.filter-bar { display: flex; gap: 1rem; flex-wrap: wrap; padding: 1rem 1.25rem; }
.filter-group { display: flex; flex-direction: column; gap: 0.25rem; min-width: 150px; }

.table-container { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
.data-table th { background: var(--bg-base); color: var(--text-secondary); font-weight: 600; text-align: left; padding: 0.75rem 1rem; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.04em; border-bottom: 1px solid var(--border-color); }
.data-table td { padding: 0.875rem 1rem; border-bottom: 1px solid var(--border-color); color: var(--text-primary); }
.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover { background: var(--bg-base); }

.student-cell { font-weight: 600; }
.points-chip { font-weight: 700; font-size: 0.9rem; }

.actions { display: flex; gap: 0.35rem; }
.icon-action { background: none; border: 1px solid var(--border-color); border-radius: 6px; padding: 4px; cursor: pointer; color: var(--text-secondary); display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
.icon-action:hover { background: var(--bg-elevated); color: var(--text-primary); }
.icon-action.edit:hover { border-color: var(--primary-600); color: var(--primary-600); }

.pagination { display: flex; justify-content: space-between; align-items: center; padding-top: 1rem; margin-top: 0.5rem; border-top: 1px solid var(--border-color); }
.pagination-info { font-size: 0.8rem; color: var(--text-secondary); }
.pagination-controls { display: flex; gap: 0.25rem; }
.page-btn { min-width: 32px; height: 32px; padding: 0 0.5rem; border: 1px solid var(--border-color); background: var(--bg-surface); color: var(--text-primary); border-radius: 6px; cursor: pointer; font-size: 0.8rem; display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
.page-btn:hover:not(:disabled) { background: var(--bg-elevated); }
.page-btn.active { background: var(--primary-600); color: white; border-color: var(--primary-600); }
.page-btn:disabled { opacity: 0.4; cursor: not-allowed; }
</style>
