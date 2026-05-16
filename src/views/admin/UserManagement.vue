<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'User Management'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">User Management</h1>
          <p class="page-subtitle">Kelola akun pengguna sistem</p>
        </div>
        <button class="btn btn-primary" @click="openAddModal">
          <span>+</span> Tambah User
        </button>
      </div>

      <!-- Filters -->
      <div class="card filter-bar">
        <div class="search-box">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
          </svg>
          <input v-model="search" type="text" placeholder="Cari nama atau email..." class="form-input" />
        </div>
        <select v-model="roleFilter" class="form-select">
          <option value="">Semua Role</option>
          <option value="admin">Admin</option>
          <option value="guru_bk">Guru BK</option>
          <option value="siswa">Siswa</option>
        </select>
      </div>

      <!-- Table -->
      <div class="card table-container">
        <table>
          <thead>
            <tr>
              <th>Nama</th>
              <th>Email</th>
              <th>Role</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in paginatedUsers" :key="user.id">
              <td>
                <div class="user-cell">
                  <div class="avatar" :style="{background: avatarColor(user.name)}">{{ user.name[0] }}</div>
                  <span>{{ user.name }}</span>
                </div>
              </td>
              <td class="text-muted">{{ user.email }}</td>
              <td>
                <span :class="roleBadge(user.role)">{{ roleLabel(user.role) }}</span>
              </td>
              <td>
                <span :class="user.active ? 'badge badge-success' : 'badge badge-danger'">
                  {{ user.active ? 'Aktif' : 'Nonaktif' }}
                </span>
              </td>
              <td>
                <div class="action-btns">
                  <button class="btn btn-outline btn-sm" @click="openEditModal(user)">Edit</button>
                  <button class="btn btn-sm btn-danger" @click="deleteUser(user.id)">Hapus</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="pagination">
          <span class="pagination-info">Menampilkan {{ paginationStart }}-{{ paginationEnd }} dari {{ filteredUsers.length }} data</span>
          <div class="pagination-btns">
            <button class="btn btn-ghost btn-sm" :disabled="currentPage === 1" @click="currentPage--">&#8249;</button>
            <button
              v-for="p in totalPages" :key="p"
              class="btn btn-sm"
              :class="p === currentPage ? 'btn-primary' : 'btn-ghost'"
              @click="currentPage = p"
            >{{ p }}</button>
            <button class="btn btn-ghost btn-sm" :disabled="currentPage === totalPages" @click="currentPage++">&#8250;</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Add/Edit Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-box">
        <div class="modal-header">
          <h3>{{ editingUser ? 'Edit User' : 'Tambah User Baru' }}</h3>
          <button class="btn btn-ghost btn-sm" @click="closeModal">&#10005;</button>
        </div>
        <form @submit.prevent="saveUser" class="modal-body">
          <div class="form-group">
            <label class="form-label">Nama Lengkap</label>
            <input v-model="form.name" type="text" class="form-input" placeholder="Masukkan nama lengkap" required />
          </div>
          <div class="form-group">
            <label class="form-label">Email</label>
            <input v-model="form.email" type="email" class="form-input" placeholder="email@sekolah.com" required />
          </div>
          <div class="form-group">
            <label class="form-label">Role</label>
            <select v-model="form.role" class="form-select" required>
              <option value="">Pilih Role</option>
              <option value="admin">Admin</option>
              <option value="guru_bk">Guru BK</option>
              <option value="siswa">Siswa</option>
            </select>
          </div>
          <div v-if="!editingUser" class="form-group">
            <label class="form-label">Password</label>
            <input v-model="form.password" type="password" class="form-input" placeholder="Minimal 8 karakter" required />
          </div>
          <div class="form-group">
            <label class="form-label">Status</label>
            <select v-model="form.active" class="form-select">
              <option :value="true">Aktif</option>
              <option :value="false">Nonaktif</option>
            </select>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline" @click="closeModal">Batal</button>
            <button type="submit" class="btn btn-primary">{{ editingUser ? 'Simpan' : 'Tambah' }}</button>
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
const roleFilter = ref('')
const currentPage = ref(1)
const perPage = 10
const showModal = ref(false)
const editingUser = ref(null)

const form = ref({ name: '', email: '', role: '', password: '', active: true })

const users = ref([
  { id: 1, name: 'Ahmad Rizki', email: 'ahmad@sekolah.com', role: 'admin', active: true },
  { id: 2, name: 'Siti Nurhaliza', email: 'siti@sekolah.com', role: 'guru_bk', active: true },
  { id: 3, name: 'Budi Santoso', email: 'budi@sekolah.com', role: 'guru_bk', active: true },
  { id: 4, name: 'Dewi Rahayu', email: 'dewi@sekolah.com', role: 'siswa', active: true },
  { id: 5, name: 'Eko Prasetyo', email: 'eko@sekolah.com', role: 'siswa', active: false },
  { id: 6, name: 'Fitriani', email: 'fitri@sekolah.com', role: 'siswa', active: true },
  { id: 7, name: 'Gunawan', email: 'gunawan@sekolah.com', role: 'guru_bk', active: true },
  { id: 8, name: 'Hendra Wijaya', email: 'hendra@sekolah.com', role: 'siswa', active: true },
  { id: 9, name: 'Indah Permata', email: 'indah@sekolah.com', role: 'siswa', active: false },
  { id: 10, name: 'Joko Susilo', email: 'joko@sekolah.com', role: 'siswa', active: true },
  { id: 11, name: 'Kartini', email: 'kartini@sekolah.com', role: 'guru_bk', active: true },
  { id: 12, name: 'Lukman Hakim', email: 'lukman@sekolah.com', role: 'siswa', active: true },
])

const filteredUsers = computed(() => {
  return users.value.filter(u => {
    const matchSearch = !search.value || u.name.toLowerCase().includes(search.value.toLowerCase()) || u.email.toLowerCase().includes(search.value.toLowerCase())
    const matchRole = !roleFilter.value || u.role === roleFilter.value
    return matchSearch && matchRole
  })
})

const totalPages = computed(() => Math.ceil(filteredUsers.value.length / perPage))
const paginationStart = computed(() => (currentPage.value - 1) * perPage + 1)
const paginationEnd = computed(() => Math.min(currentPage.value * perPage, filteredUsers.value.length))
const paginatedUsers = computed(() => filteredUsers.value.slice((currentPage.value - 1) * perPage, currentPage.value * perPage))

const avatarColors = ['#2563EB','#14B8A6','#F59E0B','#EF4444','#8B5CF6','#EC4899']
const avatarColor = (name) => avatarColors[name.charCodeAt(0) % avatarColors.length]

const roleBadge = (role) => {
  if (role === 'admin') return 'badge badge-danger'
  if (role === 'guru_bk') return 'badge badge-primary'
  return 'badge badge-success'
}
const roleLabel = (role) => ({ admin: 'Admin', guru_bk: 'Guru BK', siswa: 'Siswa' }[role] || role)

const openAddModal = () => {
  editingUser.value = null
  form.value = { name: '', email: '', role: '', password: '', active: true }
  showModal.value = true
}
const openEditModal = (user) => {
  editingUser.value = user
  form.value = { ...user }
  showModal.value = true
}
const closeModal = () => { showModal.value = false }

const saveUser = () => {
  if (editingUser.value) {
    const idx = users.value.findIndex(u => u.id === editingUser.value.id)
    if (idx !== -1) users.value[idx] = { ...users.value[idx], ...form.value }
  } else {
    users.value.push({ id: Date.now(), ...form.value })
  }
  closeModal()
}
const deleteUser = (id) => {
  if (confirm('Hapus user ini?')) users.value = users.value.filter(u => u.id !== id)
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
.pagination { display: flex; justify-content: space-between; align-items: center; padding: 16px; border-top: 1px solid #f1f5f9; }
.pagination-info { font-size: 13px; color: #64748b; }
.pagination-btns { display: flex; gap: 4px; }

.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 16px; width: 100%; max-width: 480px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.modal-header h3 { font-size: 16px; font-weight: 600; }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 8px; }
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
.btn:disabled { opacity: 0.5; cursor: not-allowed; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.badge-success { background: #dcfce7; color: #166534; }
.badge-danger { background: #fef2f2; color: #991b1b; }
.badge-warning { background: #fffbeb; color: #92400e; }
.badge-primary { background: #eff6ff; color: #1d4ed8; }
</style>
