<script setup lang="ts">
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Siswa' }, { label: 'Profil' }]

const showPasswordForm = ref(false)
const successMsg = ref('')

const profile = ref({
  name: 'Ahmad Rizky Maulana',
  nis: '20240123',
  class: 'XI IPA 2',
  school: 'SMA Negeri 4',
  birthDate: '12 Maret 2008',
  gender: 'Laki-laki',
  address: 'Jl. Melati No. 5, Jakarta Selatan',
  parentName: 'Bapak Rizky Maulana',
  parentPhone: '08123456789',
  email: 'ahmad.rizky@siswa.smavn4.sch.id',
  counselor: 'Dra. Siti Rahayu, M.Pd.',
})

const passwordForm = ref({
  current: '',
  newPass: '',
  confirm: '',
  error: '',
})

function savePassword() {
  if (!passwordForm.value.current || !passwordForm.value.newPass || !passwordForm.value.confirm) {
    passwordForm.value.error = 'Semua kolom wajib diisi.'
    return
  }
  if (passwordForm.value.newPass !== passwordForm.value.confirm) {
    passwordForm.value.error = 'Password baru dan konfirmasi tidak cocok.'
    return
  }
  if (passwordForm.value.newPass.length < 8) {
    passwordForm.value.error = 'Password minimal 8 karakter.'
    return
  }
  showPasswordForm.value = false
  passwordForm.value = { current: '', newPass: '', confirm: '', error: '' }
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
        <p class="page-subtitle">Informasi data diri dan akun kamu.</p>
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
          <div class="avatar-wrap">
            <div class="profile-avatar">AR</div>
            <div class="avatar-badge">
              <span class="badge badge-primary">Siswa</span>
            </div>
          </div>
          <div class="profile-name">{{ profile.name }}</div>
          <div class="profile-nis">NIS: {{ profile.nis }}</div>

          <div class="profile-chips">
            <div class="chip">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13">
                <path d="M12 14l9-5-9-5-9 5 9 5z M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              {{ profile.class }}
            </div>
            <div class="chip">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="13" height="13">
                <path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              {{ profile.school }}
            </div>
          </div>

          <div class="profile-stats">
            <div class="pstat">
              <div class="pstat-val red">5</div>
              <div class="pstat-lbl">Pelanggaran</div>
            </div>
            <div class="pstat-div"></div>
            <div class="pstat">
              <div class="pstat-val amber">55</div>
              <div class="pstat-lbl">Skor Evaluasi</div>
            </div>
            <div class="pstat-div"></div>
            <div class="pstat">
              <div class="pstat-val green">78%</div>
              <div class="pstat-lbl">Kedisiplinan</div>
            </div>
          </div>
        </div>

        <!-- Info Card -->
        <div class="card info-card">
          <h3 class="section-title">Data Pribadi</h3>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">Nama Lengkap</div>
              <div class="info-value">{{ profile.name }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">NIS</div>
              <div class="info-value">{{ profile.nis }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Kelas</div>
              <div class="info-value">{{ profile.class }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Tanggal Lahir</div>
              <div class="info-value">{{ profile.birthDate }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Jenis Kelamin</div>
              <div class="info-value">{{ profile.gender }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Email</div>
              <div class="info-value">{{ profile.email }}</div>
            </div>
            <div class="info-item full">
              <div class="info-label">Alamat</div>
              <div class="info-value">{{ profile.address }}</div>
            </div>
          </div>

          <div class="divider"></div>

          <h3 class="section-title">Data Keluarga & Pembimbing</h3>
          <div class="info-grid">
            <div class="info-item">
              <div class="info-label">Nama Orang Tua/Wali</div>
              <div class="info-value">{{ profile.parentName }}</div>
            </div>
            <div class="info-item">
              <div class="info-label">Nomor HP Orang Tua</div>
              <div class="info-value">{{ profile.parentPhone }}</div>
            </div>
            <div class="info-item full">
              <div class="info-label">Guru BK Pembimbing</div>
              <div class="info-value">{{ profile.counselor }}</div>
            </div>
          </div>
        </div>

        <!-- Password Card -->
        <div class="card password-card">
          <h3 class="section-title">Keamanan Akun</h3>
          <p class="password-desc">Pastikan password kamu aman dan tidak mudah ditebak orang lain.</p>

          <button v-if="!showPasswordForm" class="btn btn-outline" @click="showPasswordForm = true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/>
            </svg>
            Ganti Password
          </button>

          <div v-else class="password-form">
            <div v-if="passwordForm.error" class="error-msg">{{ passwordForm.error }}</div>
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
            <div class="form-actions">
              <button class="btn btn-outline" @click="showPasswordForm = false; passwordForm.error = ''">Batal</button>
              <button class="btn btn-primary" @click="savePassword">Simpan</button>
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

.profile-layout { display: grid; grid-template-columns: 280px 1fr; grid-template-rows: auto auto; gap: 1.5rem; }
.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.5rem; }

.profile-card { display: flex; flex-direction: column; align-items: center; text-align: center; grid-row: span 2; }
.avatar-wrap { position: relative; margin-bottom: 1rem; }
.profile-avatar { width: 80px; height: 80px; border-radius: 50%; background: var(--primary-600); color: white; font-size: 1.75rem; font-weight: 700; display: flex; align-items: center; justify-content: center; }
.avatar-badge { position: absolute; bottom: -4px; left: 50%; transform: translateX(-50%); }
.profile-name { font-size: 1.1rem; font-weight: 700; color: var(--text-primary); margin-bottom: 2px; }
.profile-nis { font-size: 0.8rem; color: var(--text-secondary); margin-bottom: 0.75rem; }
.profile-chips { display: flex; gap: 0.5rem; flex-wrap: wrap; justify-content: center; margin-bottom: 1.25rem; }
.chip { display: flex; align-items: center; gap: 0.3rem; font-size: 0.75rem; color: var(--text-secondary); background: var(--bg-base); border: 1px solid var(--border-color); border-radius: 6px; padding: 3px 8px; }
.profile-stats { display: flex; gap: 0; width: 100%; border-top: 1px solid var(--border-color); padding-top: 1.25rem; margin-top: auto; }
.pstat { flex: 1; text-align: center; }
.pstat-val { font-size: 1.25rem; font-weight: 800; color: var(--text-primary); }
.pstat-val.red { color: var(--red-500); }
.pstat-val.amber { color: var(--amber-500); }
.pstat-val.green { color: var(--green-500); }
.pstat-lbl { font-size: 0.7rem; color: var(--text-muted); }
.pstat-div { width: 1px; background: var(--border-color); }

.info-card { grid-column: 2; }
.section-title { font-size: 0.9rem; font-weight: 600; color: var(--text-primary); margin-bottom: 1rem; }
.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem 1.5rem; }
.info-item {}
.full { grid-column: span 2; }
.info-label { font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 3px; }
.info-value { font-size: 0.875rem; color: var(--text-primary); font-weight: 500; }
.divider { border: none; border-top: 1px solid var(--border-color); margin: 1.25rem 0; }

.password-card { grid-column: 2; }
.password-desc { font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 1rem; }
.error-msg { background: color-mix(in srgb, var(--red-500) 10%, transparent); border: 1px solid color-mix(in srgb, var(--red-500) 30%, transparent); color: var(--red-500); padding: 0.6rem 0.875rem; border-radius: 8px; font-size: 0.8rem; margin-bottom: 0.75rem; }
.password-form { display: flex; flex-direction: column; gap: 0.75rem; margin-top: 0.5rem; }
.form-group { display: flex; flex-direction: column; gap: 0.25rem; }
.form-actions { display: flex; gap: 0.75rem; justify-content: flex-end; }

.btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.875rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: var(--primary-600); color: white; }
.btn-outline { background: transparent; color: var(--text-primary); border: 1.5px solid var(--border-color); }

@media (max-width: 900px) {
  .profile-layout { grid-template-columns: 1fr; }
  .profile-card { grid-row: auto; }
  .info-card, .password-card { grid-column: 1; }
}
</style>
