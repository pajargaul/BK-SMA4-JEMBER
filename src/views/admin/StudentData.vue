<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Data Siswa'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Data Siswa</h1>
          <p class="page-subtitle">Kelola data siswa terdaftar</p>
        </div>
        <div style="display:flex;gap:8px;">
          <button class="btn btn-outline" @click="viewMode = viewMode === 'grid' ? 'table' : 'grid'">
            <svg v-if="viewMode==='grid'" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg>
            <svg v-else width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            {{ viewMode === 'grid' ? 'Tampilan Tabel' : 'Tampilan Grid' }}
          </button>
          <button class="btn btn-primary" @click="openAddModal">+ Tambah Siswa</button>
        </div>
      </div>

      <!-- Filters -->
      <div class="card filter-bar">
        <div class="search-box">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
          <input v-model="search" type="text" placeholder="Cari nama atau NIS..." class="form-input" />
        </div>
        <select v-model="classFilter" class="form-select">
          <option value="">Semua Kelas</option>
          <option v-for="cls in classes" :key="cls" :value="cls">{{ cls }}</option>
        </select>
      </div>

      <!-- Grid View -->
      <div v-if="viewMode === 'grid'" class="students-grid">
        <div v-for="s in filteredStudents" :key="s.id" class="student-card card">
          <div class="student-avatar" :style="{background: avatarColor(s.name)}">{{ s.name[0] }}</div>
          <h4 class="student-name">{{ s.name }}</h4>
          <p class="student-nis">NIS: {{ s.nis }}</p>
          <p class="student-class">{{ s.class_name }}</p>
          <div class="student-points">
            <span :class="pointsBadge(s.points)">{{ s.points }} Poin</span>
          </div>
          <div class="student-actions">
            <button class="btn btn-outline btn-sm" @click="openEditModal(s)">Edit</button>
            <button class="btn btn-sm btn-danger" @click="deleteStudent(s.id)">Hapus</button>
          </div>
        </div>
      </div>

      <!-- Table View -->
      <div v-else class="card table-container">
        <table>
          <thead>
            <tr>
              <th>Siswa</th>
              <th>NIS</th>
              <th>Kelas</th>
              <th>Jenis Kelamin</th>
              <th>Orang Tua</th>
              <th>Total Poin</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="s in filteredStudents" :key="s.id">
              <td>
                <div class="user-cell">
                  <div class="avatar" :style="{background: avatarColor(s.name)}">{{ s.name[0] }}</div>
                  <span>{{ s.name }}</span>
                </div>
              </td>
              <td class="text-muted">{{ s.nis }}</td>
              <td><span class="badge badge-primary">{{ s.class_name }}</span></td>
              <td class="text-muted">{{ s.gender === 'L' ? 'Laki-laki' : 'Perempuan' }}</td>
              <td class="text-muted">{{ s.parent_name }}</td>
              <td><span :class="pointsBadge(s.points)">{{ s.points }}</span></td>
              <td>
                <div class="action-btns">
                  <button class="btn btn-outline btn-sm" @click="openEditModal(s)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteStudent(s.id)">Hapus</button>
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
          <h3>{{ editingStudent ? 'Edit Siswa' : 'Tambah Siswa Baru' }}</h3>
          <button class="btn btn-ghost btn-sm" @click="closeModal">&#10005;</button>
        </div>
        <form @submit.prevent="saveStudent" class="modal-body">
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">NIS</label>
              <input v-model="form.nis" type="text" class="form-input" placeholder="Nomor Induk Siswa" required />
            </div>
            <div class="form-group">
              <label class="form-label">Jenis Kelamin</label>
              <select v-model="form.gender" class="form-select">
                <option value="L">Laki-laki</option>
                <option value="P">Perempuan</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Nama Lengkap</label>
            <input v-model="form.name" type="text" class="form-input" placeholder="Nama lengkap siswa" required />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Kelas</label>
              <select v-model="form.class_name" class="form-select" required>
                <option value="">Pilih Kelas</option>
                <option v-for="cls in classes" :key="cls" :value="cls">{{ cls }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">No. Telepon</label>
              <input v-model="form.phone" type="text" class="form-input" placeholder="08xx-xxxx-xxxx" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Nama Orang Tua</label>
              <input v-model="form.parent_name" type="text" class="form-input" placeholder="Nama orang tua/wali" />
            </div>
            <div class="form-group">
              <label class="form-label">No. HP Orang Tua</label>
              <input v-model="form.parent_phone" type="text" class="form-input" placeholder="08xx-xxxx-xxxx" />
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline" @click="closeModal">Batal</button>
            <button type="submit" class="btn btn-primary">{{ editingStudent ? 'Simpan' : 'Tambah' }}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const viewMode = ref('grid')
const search = ref('')
const classFilter = ref('')
const showModal = ref(false)
const editingStudent = ref(null)
const form = ref({ nis: '', name: '', class_name: '', gender: 'L', phone: '', parent_name: '', parent_phone: '' })

const classes = ['X-A', 'X-B', 'XI-A', 'XI-B', 'XII-A', 'XII-B']

const students = ref([
  { id: 1, nis: '2024001', name: 'Andi Firmansyah', class_name: 'X-A', gender: 'L', phone: '081234567890', parent_name: 'Budi F', parent_phone: '082234567890', points: 5 },
  { id: 2, nis: '2024002', name: 'Bella Maharani', class_name: 'X-A', gender: 'P', phone: '081234567891', parent_name: 'Citra M', parent_phone: '082234567891', points: 0 },
  { id: 3, nis: '2024003', name: 'Cahyo Nugroho', class_name: 'X-B', gender: 'L', phone: '081234567892', parent_name: 'Didi N', parent_phone: '082234567892', points: 30 },
  { id: 4, nis: '2024004', name: 'Diana Putri', class_name: 'XI-A', gender: 'P', phone: '081234567893', parent_name: 'Edi P', parent_phone: '082234567893', points: 15 },
  { id: 5, nis: '2024005', name: 'Eka Saputra', class_name: 'XI-A', gender: 'L', phone: '081234567894', parent_name: 'Feri S', parent_phone: '082234567894', points: 45 },
  { id: 6, nis: '2024006', name: 'Fajar Ramadhan', class_name: 'XI-B', gender: 'L', phone: '081234567895', parent_name: 'Gani R', parent_phone: '082234567895', points: 8 },
  { id: 7, nis: '2024007', name: 'Gita Wulandari', class_name: 'XII-A', gender: 'P', phone: '081234567896', parent_name: 'Hadi W', parent_phone: '082234567896', points: 20 },
  { id: 8, nis: '2024008', name: 'Haris Maulana', class_name: 'XII-B', gender: 'L', phone: '081234567897', parent_name: 'Irfan M', parent_phone: '082234567897', points: 60 },
])

const filteredStudents = computed(() => students.value.filter(s => {
  const matchSearch = !search.value || s.name.toLowerCase().includes(search.value.toLowerCase()) || s.nis.includes(search.value)
  const matchClass = !classFilter.value || s.class_name === classFilter.value
  return matchSearch && matchClass
}))

const avatarColors = ['#2563EB','#14B8A6','#F59E0B','#EF4444','#8B5CF6','#EC4899']
const avatarColor = (name) => avatarColors[name.charCodeAt(0) % avatarColors.length]

const pointsBadge = (pts) => {
  if (pts >= 40) return 'badge badge-danger'
  if (pts >= 20) return 'badge badge-warning'
  return 'badge badge-success'
}

const openAddModal = () => {
  editingStudent.value = null
  form.value = { nis: '', name: '', class_name: '', gender: 'L', phone: '', parent_name: '', parent_phone: '' }
  showModal.value = true
}
const openEditModal = (s) => {
  editingStudent.value = s
  form.value = { ...s }
  showModal.value = true
}
const closeModal = () => { showModal.value = false }
const saveStudent = () => {
  if (editingStudent.value) {
    const idx = students.value.findIndex(s => s.id === editingStudent.value.id)
    if (idx !== -1) students.value[idx] = { ...students.value[idx], ...form.value }
  } else {
    students.value.push({ id: Date.now(), ...form.value, points: 0 })
  }
  closeModal()
}
const deleteStudent = (id) => {
  if (confirm('Hapus data siswa ini?')) students.value = students.value.filter(s => s.id !== id)
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1200px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.filter-bar { display: flex; gap: 12px; align-items: center; margin-bottom: 20px; padding: 16px; }
.search-box { display: flex; align-items: center; gap: 8px; flex: 1; border: 1px solid var(--border-color, #e2e8f0); border-radius: 10px; padding: 8px 12px; background: #fff; }
.search-box input { border: none; outline: none; flex: 1; font-size: 14px; background: transparent; }
.search-box svg { color: #94a3b8; flex-shrink: 0; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }

.students-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; }
.student-card { padding: 24px 16px; display: flex; flex-direction: column; align-items: center; gap: 8px; text-align: center; transition: box-shadow 0.2s; }
.student-card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
.student-avatar { width: 64px; height: 64px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 24px; font-weight: 700; }
.student-name { font-size: 15px; font-weight: 600; color: var(--text-primary, #1e293b); margin: 0; }
.student-nis { font-size: 12px; color: #94a3b8; margin: 0; }
.student-class { font-size: 13px; color: #64748b; margin: 0; }
.student-points { margin: 4px 0; }
.student-actions { display: flex; gap: 8px; margin-top: 8px; }

table { width: 100%; border-collapse: collapse; }
th { padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #f1f5f9; }
td { padding: 14px 16px; font-size: 14px; color: var(--text-primary, #1e293b); border-bottom: 1px solid #f8fafc; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }
.user-cell { display: flex; align-items: center; gap: 10px; }
.avatar { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 600; font-size: 14px; flex-shrink: 0; }
.text-muted { color: #64748b; }
.action-btns { display: flex; gap: 8px; }
.btn-danger { background: #fef2f2; color: #ef4444; border: 1px solid #fecaca; }
.btn-danger:hover { background: #fee2e2; }

.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 16px; width: 100%; max-width: 540px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); max-height: 90vh; overflow-y: auto; }
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
.badge-warning { background: #fffbeb; color: #92400e; }
.badge-primary { background: #eff6ff; color: #1d4ed8; }
</style>
