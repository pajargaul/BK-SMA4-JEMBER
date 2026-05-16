<script setup lang="ts">
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Profil' }]

const isEditing = ref(false)
const showPasswordForm = ref(false)
const successMsg = ref('')

const profile = ref({
  name: 'Dra. Siti Rahayu, M.Pd.',
  nip: '198503152010012015',
  email: 'siti.rahayu@smavn4.sch.id',
  phone: '081234567890',
  address: 'Jl. Mawar No. 12, Jakarta Selatan',
  joinYear: '2010',
  subjects: 'Bimbingan Konseling',
  classes: 'X IPA 3, X IPS 1, XI IPA 2, XI IPS 3',
})

const editForm = ref({ ...profile.value })

const passwordForm = ref({
  current: '',
  newPass: '',
  confirm: '',
})

function startEdit() {
  editForm.value = { ...profile.value }
  isEditing.value = true
}

function saveProfile() {
  profile.value = { ...editForm.value }
  isEditing.value = false
  successMsg.value = 'Profil berhasil diperbarui!'
  setTimeout(() => { successMsg.value = '' }, 3000)
}

function cancelEdit() {
  isEditing.value = false
}

function savePassword() {
  if (!passwordForm.value.current || !passwordForm.value.newPass || !passwordForm.value.confirm) return
  showPasswordForm.value = false
  passwordForm.value = { current: '', newPass: '', confirm: '' }
  successMsg.value = 'Password berhasil diubah!'
  setTimeout(() => { successMsg.value = '' }, 3000)
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Profil Saya</h1>
        <p class="page-subtitle">Kelola informasi akun dan data pribadi Anda.</p>
      </div>

      <div v-if="successMsg" class="success-banner">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
          <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        {{ successMsg }}
      </div>

      <div class="profile-layout">
        <!-- Profile Card -->
        <div class="card profile-card">
          <div class="avatar-section">
            <div class="profile-avatar">SR</div>
            <div class="profile-meta">
              <div class="profile-name">{{ profile.name }}</div>
              <div class="profile-nip">NIP: {{ profile.nip }}</div>
              <span class="badge badge-teal">Guru BK</span>
            </div>
          </div>
          <div class="profile-stats">
            <div class="pstat">
              <div class="pstat-val">42</div>
              <div class="pstat-lbl">Siswa Binaan</div>
            </div>
            <div class="pstat-divider"></div>
            <div class="pstat">
              <div class="pstat-val">128</div>
              <div class="pstat-lbl">Total Kasus</div>
            </div>
            <div class="pstat-divider"></div>
            <div class="pstat">
              <div class="pstat-val">{{ profile.joinYear }}</div>
              <div class="pstat-lbl">Tahun Bergabung</div>
            </div>
          </div>
        </div>

        <!-- Info / Edit Form -->
        <div class="card info-card">
          <div class="card-header-row">
            <h3 class="section-title">Informasi Pribadi</h3>
            <button v-if="!isEditing" class="btn btn-outline btn-sm" @click="startEdit">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14">
                <path d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Edit
            </button>
          </div>

          <!-- View Mode -->
          <div v-if="!isEditing" class="info-grid">
            <div class="info-item">
              <div class="info-label">Nama Lengkap</div>
              <div class="info-value">{{ profile.name }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">NIP</div>
              <div class="info-value">{{ profile.nip }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Email</div>
              <div class="info-value">{{ profile.email }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Nomor HP</div>
              <div class="info-value">{{ profile.phone }}</div>
            </div>
            <div class="info-item full-width">
              <div class="info-label">Alamat</div>
              <div class="info-value">{{ profile.address }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Mata Pelajaran</div>
              <div class="info-value">{{ profile.subjects }}</div>
            </div>
            <div class="info-item full-width">
              <div class="info-label">Kelas Binaan</div>
              <div class="info-value">{{ profile.classes }}</div>
            </div>
          </div>

          <!-- Edit Mode -->
          <div v-else class="edit-form">
            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Nama Lengkap</label>
                <input v-model="editForm.name" class="form-input" />
              </div>
              <div class="form-group">
                <label class="form-label">NIP</label>
                <input v-model="editForm.nip" class="form-input" />
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Email</label>
                <input v-model="editForm.email" type="email" class="form-input" />
              </div>
              <div class="form-group">
                <label class="form-label">Nomor HP</label>
                <input v-model="editForm.phone" class="form-input" />
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Alamat</label>
              <textarea v-model="editForm.address" class="form-textarea" rows="2"></textarea>
            </div>
            <div class="form-group">
              <label class="form-label">Kelas Binaan</label>
              <input v-model="editForm.classes" class="form-input" />
            </div>
            <div class="edit-actions">
              <button class="btn btn-outline" @click="cancelEdit">Batal</button>
              <button class="btn btn-primary" @click="saveProfile">Simpan Perubahan</button>
            </div>
          </div>
        </div>

        <!-- Change Password -->
        <div class="card password-card">
          <div class="card-header-row">
            <h3 class="section-title">Keamanan Akun</h3>
          </div>
          <p class="password-hint">Ganti password secara berkala untuk menjaga keamanan akun Anda.</p>
          <button v-if="!showPasswordForm" class="btn btn-outline" @click="showPasswordForm = true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/>
            </svg>
            Ganti Password
          </button>
          <div v-else class="password-form">
            <div class="form-group">
              <label class="form-label">Password Saat Ini</label>
              <input v-model="passwordForm.current" type="password" class="form-input" placeholder="Masukkan password lama" />
            </div>
            <div class="form-group">
              <label class="form-label">Password Baru</label>
              <input v-model="passwordForm.newPass" type="password" class="form-input" placeholder="Minimal 8 karakter" />
            </div>
            <div class="form-group">
              <label class="form-label">Konfirmasi Password Baru</label>
              <input v-model="passwordForm.confirm" type="password" class="form-input" placeholder="Ulangi password baru" />
            </div>
            <div class="edit-actions">
              <button class="btn btn-outline" @click="showPasswordForm = false">Batal</button>
              <button class="btn btn-primary" @click="savePassword">Simpan Password</button>
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

.success-banner { display: flex; align-items: center; gap: 0.5rem; background: color-mix(in srgb, var(--green-500) 12%, transparent); border: 1px solid color-mix(in srgb, var(--green-500) 30%, transparent); color: var(--green-500); padding: 0.75rem 1rem; border-radius: 8px; font-size: 0.875rem; font-weight: 600; margin-bottom: 1.25rem; }

.profile-layout { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.5rem; }

.profile-card {}
.avatar-section { display: flex; align-items: center; gap: 1.25rem; margin-bottom: 1.5rem; }
.profile-avatar { width: 72px; height: 72px; border-radius: 50%; background: var(--teal-500); color: white; font-size: 1.5rem; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.profile-name { font-size: 1.1rem; font-weight: 700; color: var(--text-primary); margin-bottom: 2px; }
.profile-nip { font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 6px; }
.profile-stats { display: flex; gap: 1.5rem; border-top: 1px solid var(--border-color); padding-top: 1.25rem; }
.pstat { text-align: center; flex: 1; }
.pstat-val { font-size: 1.4rem; font-weight: 700; color: var(--text-primary); }
.pstat-lbl { font-size: 0.75rem; color: var(--text-secondary); margin-top: 2px; }
.pstat-divider { width: 1px; background: var(--border-color); }

.card-header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-color); }
.section-title { font-size: 0.95rem; font-weight: 600; color: var(--text-primary); }

.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
.info-item {}
.full-width { grid-column: span 2; }
.info-label { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 3px; }
.info-value { font-size: 0.875rem; color: var(--text-primary); font-weight: 500; }

.edit-form { display: flex; flex-direction: column; gap: 0.75rem; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; }
.edit-actions { display: flex; gap: 0.75rem; justify-content: flex-end; padding-top: 0.75rem; }

.password-hint { font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 1rem; }
.password-form { display: flex; flex-direction: column; gap: 0.75rem; margin-top: 1rem; }

.btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.875rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: var(--primary-600); color: white; }
.btn-outline { background: transparent; color: var(--text-primary); border: 1.5px solid var(--border-color); }
.btn-sm { padding: 0.35rem 0.875rem; font-size: 0.8rem; }
</style>
