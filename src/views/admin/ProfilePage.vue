<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Profil'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Profil Saya</h1>
          <p class="page-subtitle">Kelola informasi akun dan keamanan</p>
        </div>
      </div>

      <div class="profile-layout">
        <!-- Profile Card -->
        <div class="profile-sidebar">
          <div class="card profile-card">
            <div class="profile-cover"></div>
            <div class="profile-avatar-wrap">
              <div class="profile-avatar" :style="{background: avatarColor}">
                {{ profile.full_name[0] }}
              </div>
              <button class="avatar-edit-btn" @click="triggerAvatarUpload" title="Ganti foto">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
              </button>
            </div>
            <div class="profile-info">
              <h3>{{ profile.full_name }}</h3>
              <span class="badge badge-primary">{{ roleLabel }}</span>
              <p class="profile-email">{{ profile.email }}</p>
            </div>
            <div class="profile-stats">
              <div class="pstat">
                <span class="pstat-val">{{ profile.loginCount }}</span>
                <span class="pstat-label">Login</span>
              </div>
              <div class="pstat-divider"></div>
              <div class="pstat">
                <span class="pstat-val">{{ profile.actionsCount }}</span>
                <span class="pstat-label">Aksi</span>
              </div>
              <div class="pstat-divider"></div>
              <div class="pstat">
                <span class="pstat-val">{{ profile.daysSince }}</span>
                <span class="pstat-label">Hari</span>
              </div>
            </div>
            <div class="profile-joined">
              <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
              Bergabung sejak {{ profile.joinedAt }}
            </div>
          </div>

          <!-- Quick Info -->
          <div class="card quick-info-card">
            <h4>Informasi Cepat</h4>
            <div class="info-rows">
              <div class="info-row">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.56 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                <span>{{ profile.phone || 'Belum diisi' }}</span>
              </div>
              <div class="info-row">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                <span>{{ profile.address || 'Belum diisi' }}</span>
              </div>
              <div class="info-row">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                <span>Login terakhir: {{ profile.lastLogin }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Main Content -->
        <div class="profile-main">
          <!-- Edit Profile -->
          <div class="card settings-card">
            <div class="card-section-header">
              <h3>Edit Profil</h3>
              <p>Perbarui informasi personal Anda</p>
            </div>
            <form @submit.prevent="saveProfile" class="settings-form">
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">Nama Lengkap</label>
                  <input v-model="editForm.full_name" type="text" class="form-input" required />
                </div>
                <div class="form-group">
                  <label class="form-label">Email</label>
                  <input v-model="editForm.email" type="email" class="form-input" required />
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">No. Telepon</label>
                  <input v-model="editForm.phone" type="text" class="form-input" placeholder="08xx-xxxx-xxxx" />
                </div>
                <div class="form-group">
                  <label class="form-label">Role</label>
                  <input :value="roleLabel" type="text" class="form-input" disabled style="background:#f8fafc;color:#94a3b8;" />
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Alamat</label>
                <textarea v-model="editForm.address" class="form-input" rows="2" placeholder="Alamat tempat tinggal..."></textarea>
              </div>
              <div class="form-actions">
                <button type="submit" class="btn btn-primary" :disabled="profileSaving">
                  <svg v-if="profileSaving" class="spin" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
                  {{ profileSaving ? 'Menyimpan...' : 'Simpan Profil' }}
                </button>
              </div>
            </form>
          </div>

          <!-- Change Password -->
          <div class="card settings-card">
            <div class="card-section-header">
              <h3>Ubah Password</h3>
              <p>Pastikan password baru Anda kuat dan aman</p>
            </div>
            <form @submit.prevent="changePassword" class="settings-form">
              <div class="form-group">
                <label class="form-label">Password Saat Ini</label>
                <div class="password-input">
                  <input v-model="pwForm.current" :type="showPw.current ? 'text' : 'password'" class="form-input" placeholder="Masukkan password saat ini" required />
                  <button type="button" class="pw-toggle" @click="showPw.current = !showPw.current">
                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <path v-if="showPw.current" d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                      <line v-if="showPw.current" x1="1" y1="1" x2="23" y2="23"/>
                      <path v-else d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                      <circle v-if="!showPw.current" cx="12" cy="12" r="3"/>
                    </svg>
                  </button>
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">Password Baru</label>
                  <div class="password-input">
                    <input v-model="pwForm.newPw" :type="showPw.new ? 'text' : 'password'" class="form-input" placeholder="Min. 8 karakter" required />
                    <button type="button" class="pw-toggle" @click="showPw.new = !showPw.new">
                      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Konfirmasi Password</label>
                  <div class="password-input">
                    <input v-model="pwForm.confirm" :type="showPw.confirm ? 'text' : 'password'" class="form-input" placeholder="Ulangi password baru" required />
                    <button type="button" class="pw-toggle" @click="showPw.confirm = !showPw.confirm">
                      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                    </button>
                  </div>
                </div>
              </div>

              <!-- Password Strength -->
              <div v-if="pwForm.newPw" class="pw-strength">
                <div class="pw-bars">
                  <div v-for="i in 4" :key="i" class="pw-bar" :class="pwStrength >= i ? pwStrengthClass : ''"></div>
                </div>
                <span class="pw-label">{{ pwStrengthLabel }}</span>
              </div>

              <div v-if="pwError" class="error-msg">{{ pwError }}</div>

              <div class="form-actions">
                <button type="submit" class="btn btn-primary" :disabled="pwSaving">
                  {{ pwSaving ? 'Memperbarui...' : 'Ubah Password' }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast -->
    <div v-if="showToast" class="save-toast">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      {{ toastMessage }}
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const profileSaving = ref(false)
const pwSaving = ref(false)
const showToast = ref(false)
const toastMessage = ref('')
const pwError = ref('')
const showPw = ref({ current: false, new: false, confirm: false })

const profile = ref({
  full_name: 'Ahmad Rizki Pratama',
  email: 'ahmad@sekolah.com',
  role: 'admin',
  phone: '081234567890',
  address: 'Jl. Merdeka No. 10, Jakarta Pusat',
  loginCount: 142,
  actionsCount: 387,
  daysSince: 180,
  joinedAt: '1 Januari 2025',
  lastLogin: '15 Mei 2025, 08:30',
})

const editForm = ref({
  full_name: profile.value.full_name,
  email: profile.value.email,
  phone: profile.value.phone,
  address: profile.value.address,
})

const pwForm = ref({ current: '', newPw: '', confirm: '' })

const roleLabel = computed(() => ({ admin: 'Admin', guru_bk: 'Guru BK', siswa: 'Siswa' }[profile.value.role] || profile.value.role))

const avatarColors = ['#2563EB', '#14B8A6', '#F59E0B', '#EF4444', '#8B5CF6']
const avatarColor = computed(() => avatarColors[profile.value.full_name.charCodeAt(0) % avatarColors.length])

const pwStrength = computed(() => {
  const pw = pwForm.value.newPw
  let score = 0
  if (pw.length >= 8) score++
  if (/[A-Z]/.test(pw)) score++
  if (/[0-9]/.test(pw)) score++
  if (/[^a-zA-Z0-9]/.test(pw)) score++
  return score
})

const pwStrengthLabel = computed(() => ['Sangat Lemah', 'Lemah', 'Cukup', 'Kuat', 'Sangat Kuat'][pwStrength.value] || '')
const pwStrengthClass = computed(() => ['', 'weak', 'weak', 'medium', 'strong'][pwStrength.value] || '')

const triggerAvatarUpload = () => alert('Fitur upload foto profil')

const saveProfile = async () => {
  profileSaving.value = true
  await new Promise(r => setTimeout(r, 1000))
  Object.assign(profile.value, editForm.value)
  profileSaving.value = false
  showSuccessToast('Profil berhasil diperbarui!')
}

const changePassword = async () => {
  pwError.value = ''
  if (pwForm.value.newPw !== pwForm.value.confirm) {
    pwError.value = 'Password baru dan konfirmasi tidak cocok.'
    return
  }
  if (pwForm.value.newPw.length < 8) {
    pwError.value = 'Password minimal 8 karakter.'
    return
  }
  pwSaving.value = true
  await new Promise(r => setTimeout(r, 1000))
  pwSaving.value = false
  pwForm.value = { current: '', newPw: '', confirm: '' }
  showSuccessToast('Password berhasil diperbarui!')
}

const showSuccessToast = (msg) => {
  toastMessage.value = msg
  showToast.value = true
  setTimeout(() => { showToast.value = false }, 3000)
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1100px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.profile-layout { display: grid; grid-template-columns: 280px 1fr; gap: 20px; align-items: start; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.profile-sidebar { display: flex; flex-direction: column; gap: 16px; position: sticky; top: 24px; }
.profile-card { overflow: hidden; }
.profile-cover { height: 80px; background: linear-gradient(135deg, #2563EB 0%, #14B8A6 100%); }
.profile-avatar-wrap { position: relative; display: inline-block; margin: -36px 0 0 20px; }
.profile-avatar { width: 72px; height: 72px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 28px; font-weight: 700; border: 4px solid #fff; }
.avatar-edit-btn { position: absolute; bottom: 2px; right: 2px; width: 24px; height: 24px; background: #2563eb; border: 2px solid #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; cursor: pointer; }
.profile-info { padding: 12px 20px 0; display: flex; flex-direction: column; gap: 4px; }
.profile-info h3 { font-size: 16px; font-weight: 700; margin: 0; }
.profile-email { font-size: 12px; color: #94a3b8; margin: 2px 0 0; }
.profile-stats { display: flex; align-items: center; padding: 16px 20px; border-top: 1px solid #f1f5f9; margin-top: 12px; }
.pstat { flex: 1; text-align: center; }
.pstat-val { display: block; font-size: 18px; font-weight: 700; color: var(--text-primary, #1e293b); }
.pstat-label { font-size: 11px; color: #94a3b8; }
.pstat-divider { width: 1px; height: 32px; background: #f1f5f9; }
.profile-joined { display: flex; align-items: center; gap: 6px; padding: 12px 20px; border-top: 1px solid #f1f5f9; font-size: 12px; color: #94a3b8; }
.quick-info-card { padding: 16px 20px; }
.quick-info-card h4 { font-size: 13px; font-weight: 600; margin: 0 0 12px; color: #374151; }
.info-rows { display: flex; flex-direction: column; gap: 10px; }
.info-row { display: flex; align-items: flex-start; gap: 10px; font-size: 13px; color: #64748b; }
.info-row svg { color: #94a3b8; flex-shrink: 0; margin-top: 1px; }
.profile-main { display: flex; flex-direction: column; gap: 20px; }
.settings-card { overflow: hidden; }
.card-section-header { padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.card-section-header h3 { font-size: 16px; font-weight: 600; margin: 0 0 4px; }
.card-section-header p { font-size: 13px; color: #64748b; margin: 0; }
.settings-form { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-label { font-size: 13px; font-weight: 500; color: #374151; }
.form-input { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.2s; width: 100%; box-sizing: border-box; resize: vertical; }
.form-input:focus { border-color: #2563eb; }
.password-input { position: relative; }
.password-input .form-input { padding-right: 40px; }
.pw-toggle { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #94a3b8; display: flex; align-items: center; }
.pw-strength { display: flex; align-items: center; gap: 10px; }
.pw-bars { display: flex; gap: 4px; }
.pw-bar { width: 40px; height: 4px; background: #e2e8f0; border-radius: 2px; }
.pw-bar.weak { background: #ef4444; }
.pw-bar.medium { background: #f59e0b; }
.pw-bar.strong { background: #22c55e; }
.pw-label { font-size: 12px; color: #64748b; }
.error-msg { background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; border-radius: 10px; padding: 10px 14px; font-size: 13px; }
.form-actions { display: flex; justify-content: flex-end; }
.save-toast { position: fixed; bottom: 24px; right: 24px; background: #16a34a; color: #fff; padding: 12px 20px; border-radius: 12px; font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 8px; box-shadow: 0 8px 30px rgba(0,0,0,0.15); z-index: 9999; animation: slideUp 0.3s ease; }
@keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-primary:disabled { opacity: 0.7; cursor: not-allowed; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.badge-primary { background: #eff6ff; color: #1d4ed8; }
@media (max-width: 768px) {
  .profile-layout { grid-template-columns: 1fr; }
  .profile-sidebar { position: static; }
}
</style>
