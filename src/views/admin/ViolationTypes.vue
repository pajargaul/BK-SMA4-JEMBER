<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Jenis Pelanggaran'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Jenis Pelanggaran</h1>
          <p class="page-subtitle">Kelola jenis dan bobot pelanggaran siswa</p>
        </div>
        <button class="btn btn-primary" @click="openAddModal">+ Tambah Jenis</button>
      </div>

      <!-- Filters -->
      <div class="card filter-bar">
        <div class="search-box">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
          <input v-model="search" type="text" placeholder="Cari jenis pelanggaran..." class="form-input" />
        </div>
        <select v-model="categoryFilter" class="form-select">
          <option value="">Semua Kategori</option>
          <option v-for="cat in categoryOptions" :key="cat" :value="cat">{{ cat }}</option>
        </select>
        <select v-model="severityFilter" class="form-select">
          <option value="">Semua Tingkat</option>
          <option value="ringan">Ringan</option>
          <option value="sedang">Sedang</option>
          <option value="berat">Berat</option>
        </select>
      </div>

      <!-- Table -->
      <div class="card table-container">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Nama Pelanggaran</th>
              <th>Kategori</th>
              <th>Tingkat Keparahan</th>
              <th>Poin</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(vt, idx) in filteredTypes" :key="vt.id">
              <td class="text-muted">{{ idx + 1 }}</td>
              <td>
                <div>
                  <p class="vt-name">{{ vt.name }}</p>
                  <p class="vt-desc">{{ vt.description }}</p>
                </div>
              </td>
              <td>
                <span class="badge" :style="{background: catColor(vt.category) + '20', color: catColor(vt.category)}">
                  {{ vt.category }}
                </span>
              </td>
              <td>
                <span :class="severityBadge(vt.severity)">{{ severityLabel(vt.severity) }}</span>
              </td>
              <td>
                <span class="points-pill">{{ vt.points }} poin</span>
              </td>
              <td>
                <div class="action-btns">
                  <button class="btn btn-outline btn-sm" @click="openEditModal(vt)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteType(vt.id)">Hapus</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-box">
        <div class="modal-header">
          <h3>{{ editingType ? 'Edit Jenis Pelanggaran' : 'Tambah Jenis Pelanggaran' }}</h3>
          <button class="btn btn-ghost btn-sm" @click="closeModal">&#10005;</button>
        </div>
        <form @submit.prevent="saveType" class="modal-body">
          <div class="form-group">
            <label class="form-label">Nama Pelanggaran</label>
            <input v-model="form.name" type="text" class="form-input" placeholder="Nama jenis pelanggaran" required />
          </div>
          <div class="form-group">
            <label class="form-label">Deskripsi</label>
            <textarea v-model="form.description" class="form-input" rows="2" placeholder="Deskripsi pelanggaran..."></textarea>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Kategori</label>
              <select v-model="form.category" class="form-select" required>
                <option value="">Pilih Kategori</option>
                <option v-for="cat in categoryOptions" :key="cat" :value="cat">{{ cat }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Tingkat Keparahan</label>
              <select v-model="form.severity" class="form-select" required>
                <option value="">Pilih Tingkat</option>
                <option value="ringan">Ringan</option>
                <option value="sedang">Sedang</option>
                <option value="berat">Berat</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Poin Pelanggaran</label>
            <input v-model.number="form.points" type="number" class="form-input" min="1" max="100" placeholder="Contoh: 10" required />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline" @click="closeModal">Batal</button>
            <button type="submit" class="btn btn-primary">{{ editingType ? 'Simpan' : 'Tambah' }}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const search = ref('')
const categoryFilter = ref('')
const severityFilter = ref('')
const showModal = ref(false)
const editingType = ref(null)
const form = ref({ name: '', description: '', category: '', severity: '', points: 10 })

const categoryOptions = ['Kedisiplinan', 'Akademik', 'Penampilan', 'Perilaku', 'Teknologi', 'Sosial']
const catColorMap = { Kedisiplinan: '#2563EB', Akademik: '#14B8A6', Penampilan: '#F59E0B', Perilaku: '#EF4444', Teknologi: '#8B5CF6', Sosial: '#EC4899' }
const catColor = (cat) => catColorMap[cat] || '#94a3b8'

const violationTypes = ref([
  { id: 1, name: 'Terlambat masuk sekolah', description: 'Siswa datang setelah bel masuk berbunyi', category: 'Kedisiplinan', severity: 'ringan', points: 5 },
  { id: 2, name: 'Tidak mengerjakan PR', description: 'Tidak menyelesaikan pekerjaan rumah', category: 'Akademik', severity: 'ringan', points: 5 },
  { id: 3, name: 'Seragam tidak lengkap', description: 'Tidak memakai atribut seragam lengkap', category: 'Penampilan', severity: 'ringan', points: 5 },
  { id: 4, name: 'Membolos kelas', description: 'Tidak hadir di kelas tanpa izin', category: 'Kedisiplinan', severity: 'sedang', points: 15 },
  { id: 5, name: 'Berkelahi', description: 'Terlibat perkelahian dengan siswa lain', category: 'Perilaku', severity: 'berat', points: 40 },
  { id: 6, name: 'Menggunakan HP saat pelajaran', description: 'Memakai ponsel tanpa izin guru', category: 'Teknologi', severity: 'sedang', points: 10 },
  { id: 7, name: 'Tidak hormat kepada guru', description: 'Bersikap tidak sopan terhadap guru', category: 'Sosial', severity: 'sedang', points: 20 },
  { id: 8, name: 'Menyontek saat ujian', description: 'Kecurangan dalam ujian atau ulangan', category: 'Akademik', severity: 'berat', points: 35 },
])

const filteredTypes = computed(() => violationTypes.value.filter(vt => {
  const matchSearch = !search.value || vt.name.toLowerCase().includes(search.value.toLowerCase())
  const matchCat = !categoryFilter.value || vt.category === categoryFilter.value
  const matchSev = !severityFilter.value || vt.severity === severityFilter.value
  return matchSearch && matchCat && matchSev
}))

const severityBadge = (s) => s === 'berat' ? 'badge badge-danger' : s === 'sedang' ? 'badge badge-warning' : 'badge badge-success'
const severityLabel = (s) => ({ ringan: 'Ringan', sedang: 'Sedang', berat: 'Berat' }[s] || s)

const openAddModal = () => {
  editingType.value = null
  form.value = { name: '', description: '', category: '', severity: '', points: 10 }
  showModal.value = true
}
const openEditModal = (vt) => {
  editingType.value = vt
  form.value = { ...vt }
  showModal.value = true
}
const closeModal = () => { showModal.value = false }
const saveType = () => {
  if (editingType.value) {
    const idx = violationTypes.value.findIndex(v => v.id === editingType.value.id)
    if (idx !== -1) violationTypes.value[idx] = { ...violationTypes.value[idx], ...form.value }
  } else {
    violationTypes.value.push({ id: Date.now(), ...form.value })
  }
  closeModal()
}
const deleteType = (id) => {
  if (confirm('Hapus jenis pelanggaran ini?')) violationTypes.value = violationTypes.value.filter(v => v.id !== id)
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1200px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.filter-bar { display: flex; gap: 12px; align-items: center; margin-bottom: 20px; padding: 16px; }
.search-box { display: flex; align-items: center; gap: 8px; flex: 1; border: 1px solid #e2e8f0; border-radius: 10px; padding: 8px 12px; background: #f8fafc; }
.search-box input { border: none; outline: none; flex: 1; font-size: 14px; background: transparent; }
.search-box svg { color: #94a3b8; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
table { width: 100%; border-collapse: collapse; }
th { padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #f1f5f9; }
td { padding: 14px 16px; font-size: 14px; color: var(--text-primary, #1e293b); border-bottom: 1px solid #f8fafc; vertical-align: middle; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }
.vt-name { font-weight: 500; margin: 0; }
.vt-desc { font-size: 12px; color: #94a3b8; margin: 2px 0 0; }
.text-muted { color: #94a3b8; }
.action-btns { display: flex; gap: 8px; }
.btn-danger { background: #fef2f2; color: #ef4444; border: 1px solid #fecaca; }
.points-pill { background: #f1f5f9; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; color: #1e293b; }
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 16px; width: 100%; max-width: 500px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.modal-header h3 { font-size: 16px; font-weight: 600; }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 8px; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-label { font-size: 13px; font-weight: 500; color: #374151; }
.form-input { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.2s; width: 100%; box-sizing: border-box; resize: vertical; }
.form-input:focus { border-color: #2563eb; }
.form-select { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; }
.form-select:focus { border-color: #2563eb; }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-outline { background: transparent; border: 1px solid #d1d5db; color: #374151; }
.btn-outline:hover { background: #f9fafb; }
.btn-ghost { background: transparent; color: #64748b; }
.btn-ghost:hover { background: #f1f5f9; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.badge-success { background: #dcfce7; color: #166534; }
.badge-danger { background: #fef2f2; color: #991b1b; }
.badge-warning { background: #fffbeb; color: #92400e; }
</style>
