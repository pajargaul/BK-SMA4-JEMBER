<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Data Guru BK'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Data Guru BK</h1>
          <p class="page-subtitle">Kelola data guru bimbingan konseling</p>
        </div>
        <button class="btn btn-primary" @click="openAddModal">+ Tambah Guru BK</button>
      </div>

      <!-- Stats -->
      <div class="stats-row">
        <div class="stats-card">
          <div class="stats-icon" style="background:#eff6ff;color:#2563eb;">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          </div>
          <div>
            <p class="stats-label">Total Guru BK</p>
            <p class="stats-value">{{ teachers.length }}</p>
          </div>
        </div>
        <div class="stats-card">
          <div class="stats-icon" style="background:#dcfce7;color:#166534;">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
          </div>
          <div>
            <p class="stats-label">Aktif</p>
            <p class="stats-value">{{ teachers.filter(t => t.active).length }}</p>
          </div>
        </div>
      </div>

      <!-- Table -->
      <div class="card table-container">
        <div class="table-toolbar">
          <div class="search-box">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input v-model="search" type="text" placeholder="Cari nama atau NIP..." class="form-input" />
          </div>
        </div>
        <table>
          <thead>
            <tr>
              <th>Foto</th>
              <th>Nama</th>
              <th>NIP</th>
              <th>Spesialisasi</th>
              <th>Telepon</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="t in filteredTeachers" :key="t.id">
              <td>
                <div class="avatar" :style="{background: avatarColor(t.name)}">{{ t.name[0] }}</div>
              </td>
              <td>
                <div>
                  <p class="teacher-name">{{ t.name }}</p>
                  <p class="teacher-email">{{ t.email }}</p>
                </div>
              </td>
              <td class="text-muted">{{ t.nip }}</td>
              <td><span class="badge badge-primary">{{ t.specialization }}</span></td>
              <td class="text-muted">{{ t.phone }}</td>
              <td>
                <span :class="t.active ? 'badge badge-success' : 'badge badge-danger'">
                  {{ t.active ? 'Aktif' : 'Nonaktif' }}
                </span>
              </td>
              <td>
                <div class="action-btns">
                  <button class="btn btn-outline btn-sm" @click="openEditModal(t)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteTeacher(t.id)">Hapus</button>
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
          <h3>{{ editingTeacher ? 'Edit Guru BK' : 'Tambah Guru BK' }}</h3>
          <button class="btn btn-ghost btn-sm" @click="closeModal">&#10005;</button>
        </div>
        <form @submit.prevent="saveTeacher" class="modal-body">
          <div class="form-group">
            <label class="form-label">Nama Lengkap</label>
            <input v-model="form.name" type="text" class="form-input" placeholder="Nama lengkap" required />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">NIP</label>
              <input v-model="form.nip" type="text" class="form-input" placeholder="Nomor Induk Pegawai" required />
            </div>
            <div class="form-group">
              <label class="form-label">No. Telepon</label>
              <input v-model="form.phone" type="text" class="form-input" placeholder="08xx-xxxx-xxxx" />
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Email</label>
            <input v-model="form.email" type="email" class="form-input" placeholder="email@sekolah.com" />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Spesialisasi</label>
              <select v-model="form.specialization" class="form-select">
                <option value="Konseling Individu">Konseling Individu</option>
                <option value="Konseling Kelompok">Konseling Kelompok</option>
                <option value="Pengembangan Karir">Pengembangan Karir</option>
                <option value="Konseling Keluarga">Konseling Keluarga</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Status</label>
              <select v-model="form.active" class="form-select">
                <option :value="true">Aktif</option>
                <option :value="false">Nonaktif</option>
              </select>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline" @click="closeModal">Batal</button>
            <button type="submit" class="btn btn-primary">{{ editingTeacher ? 'Simpan' : 'Tambah' }}</button>
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
const showModal = ref(false)
const editingTeacher = ref(null)
const form = ref({ name: '', nip: '', phone: '', email: '', specialization: 'Konseling Individu', active: true })

const teachers = ref([
  { id: 1, name: 'Dra. Siti Aminah', nip: '196501011990032001', phone: '081234567800', email: 'siti.aminah@sekolah.com', specialization: 'Konseling Individu', active: true },
  { id: 2, name: 'Bpk. Rudi Hartono', nip: '197203151997031002', phone: '081234567801', email: 'rudi.hartono@sekolah.com', specialization: 'Konseling Kelompok', active: true },
  { id: 3, name: 'Ibu Wulan Dari', nip: '198008202006042003', phone: '081234567802', email: 'wulan.dari@sekolah.com', specialization: 'Pengembangan Karir', active: true },
  { id: 4, name: 'Bpk. Eko Santoso', nip: '197512301999031004', phone: '081234567803', email: 'eko.santoso@sekolah.com', specialization: 'Konseling Keluarga', active: false },
])

const filteredTeachers = computed(() => teachers.value.filter(t => {
  return !search.value || t.name.toLowerCase().includes(search.value.toLowerCase()) || t.nip.includes(search.value)
}))

const avatarColors = ['#2563EB','#14B8A6','#F59E0B','#EF4444','#8B5CF6']
const avatarColor = (name) => avatarColors[name.charCodeAt(0) % avatarColors.length]

const openAddModal = () => {
  editingTeacher.value = null
  form.value = { name: '', nip: '', phone: '', email: '', specialization: 'Konseling Individu', active: true }
  showModal.value = true
}
const openEditModal = (t) => {
  editingTeacher.value = t
  form.value = { ...t }
  showModal.value = true
}
const closeModal = () => { showModal.value = false }
const saveTeacher = () => {
  if (editingTeacher.value) {
    const idx = teachers.value.findIndex(t => t.id === editingTeacher.value.id)
    if (idx !== -1) teachers.value[idx] = { ...teachers.value[idx], ...form.value }
  } else {
    teachers.value.push({ id: Date.now(), ...form.value })
  }
  closeModal()
}
const deleteTeacher = (id) => {
  if (confirm('Hapus data guru ini?')) teachers.value = teachers.value.filter(t => t.id !== id)
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1200px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.stats-row { display: flex; gap: 16px; margin-bottom: 20px; }
.stats-card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); padding: 16px 20px; display: flex; align-items: center; gap: 16px; flex: 0 0 auto; }
.stats-icon { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; }
.stats-label { font-size: 12px; color: #64748b; margin: 0; }
.stats-value { font-size: 22px; font-weight: 700; color: var(--text-primary, #1e293b); margin: 0; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.table-toolbar { padding: 16px; border-bottom: 1px solid #f1f5f9; }
.search-box { display: flex; align-items: center; gap: 8px; max-width: 320px; border: 1px solid #e2e8f0; border-radius: 10px; padding: 8px 12px; background: #f8fafc; }
.search-box input { border: none; outline: none; flex: 1; font-size: 14px; background: transparent; }
.search-box svg { color: #94a3b8; flex-shrink: 0; }
table { width: 100%; border-collapse: collapse; }
th { padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #f1f5f9; }
td { padding: 14px 16px; font-size: 14px; color: var(--text-primary, #1e293b); border-bottom: 1px solid #f8fafc; vertical-align: middle; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }
.avatar { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 600; font-size: 16px; }
.teacher-name { font-weight: 500; margin: 0; }
.teacher-email { font-size: 12px; color: #94a3b8; margin: 0; }
.text-muted { color: #64748b; }
.action-btns { display: flex; gap: 8px; }
.btn-danger { background: #fef2f2; color: #ef4444; border: 1px solid #fecaca; }
.btn-danger:hover { background: #fee2e2; }
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 16px; width: 100%; max-width: 520px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.modal-header h3 { font-size: 16px; font-weight: 600; }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 8px; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-label { font-size: 13px; font-weight: 500; color: #374151; }
.form-input, .form-select { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.2s; }
.form-input:focus, .form-select:focus { border-color: #2563eb; }
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
.badge-primary { background: #eff6ff; color: #1d4ed8; }
</style>
