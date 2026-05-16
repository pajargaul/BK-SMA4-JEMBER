<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Pengaturan'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Pengaturan Sistem</h1>
          <p class="page-subtitle">Konfigurasi sekolah dan preferensi sistem</p>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline" @click="resetSettings">Reset</button>
          <button class="btn btn-primary" @click="saveSettings" :disabled="saving">
            <svg v-if="saving" class="spin" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
            {{ saving ? 'Menyimpan...' : 'Simpan Pengaturan' }}
          </button>
        </div>
      </div>

      <div class="settings-layout">
        <!-- Left: Navigation -->
        <div class="settings-nav card">
          <button
            v-for="tab in tabs" :key="tab.id"
            :class="['nav-item', activeTab === tab.id ? 'active' : '']"
            @click="activeTab = tab.id"
          >
            <span class="nav-icon" v-html="tab.icon"></span>
            {{ tab.label }}
          </button>
        </div>

        <!-- Right: Content -->
        <div class="settings-content">

          <!-- School Settings -->
          <div v-if="activeTab === 'school'" class="card settings-card">
            <div class="card-section-header">
              <h3>Informasi Sekolah</h3>
              <p>Detail dan identitas sekolah yang ditampilkan pada laporan</p>
            </div>
            <div class="settings-form">
              <div class="logo-upload-area">
                <div class="logo-preview">
                  <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </div>
                <div class="upload-info">
                  <p class="upload-title">Logo Sekolah</p>
                  <p class="upload-hint">PNG, JPG atau SVG. Maks 2MB. Disarankan 200x200px.</p>
                  <button class="btn btn-outline btn-sm" type="button">Unggah Logo</button>
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">Nama Sekolah</label>
                  <input v-model="school.name" type="text" class="form-input" placeholder="Nama lengkap sekolah" />
                </div>
                <div class="form-group">
                  <label class="form-label">NPSN</label>
                  <input v-model="school.npsn" type="text" class="form-input" placeholder="Nomor Pokok Sekolah Nasional" />
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">Alamat Lengkap</label>
                <textarea v-model="school.address" class="form-input" rows="3" placeholder="Alamat lengkap sekolah..."></textarea>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">Kota/Kabupaten</label>
                  <input v-model="school.city" type="text" class="form-input" placeholder="Kota" />
                </div>
                <div class="form-group">
                  <label class="form-label">Tahun Ajaran</label>
                  <select v-model="school.academicYear" class="form-select">
                    <option value="2024/2025">2024/2025</option>
                    <option value="2025/2026">2025/2026</option>
                  </select>
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="form-label">Telepon Sekolah</label>
                  <input v-model="school.phone" type="text" class="form-input" placeholder="(0xxx) xxx-xxx" />
                </div>
                <div class="form-group">
                  <label class="form-label">Email Sekolah</label>
                  <input v-model="school.email" type="email" class="form-input" placeholder="info@sekolah.sch.id" />
                </div>
              </div>
            </div>
          </div>

          <!-- System Settings -->
          <div v-if="activeTab === 'system'" class="card settings-card">
            <div class="card-section-header">
              <h3>Pengaturan Sistem</h3>
              <p>Konfigurasi perilaku dan batas sistem</p>
            </div>
            <div class="settings-form">
              <div class="form-group">
                <label class="form-label">Frekuensi Backup Otomatis</label>
                <select v-model="system.backupFrequency" class="form-select">
                  <option value="daily">Setiap Hari</option>
                  <option value="weekly">Setiap Minggu</option>
                  <option value="monthly">Setiap Bulan</option>
                  <option value="never">Tidak Pernah</option>
                </select>
                <span class="form-hint">Backup otomatis dijalankan pada pukul 02:00 dini hari</span>
              </div>

              <div class="form-group">
                <label class="form-label">Batas Poin Referral Otomatis</label>
                <div class="input-with-unit">
                  <input v-model.number="system.maxPointsBeforeReferral" type="number" class="form-input" min="10" max="200" />
                  <span class="unit-label">poin</span>
                </div>
                <span class="form-hint">Siswa dengan total poin melebihi batas ini akan otomatis mendapat notifikasi referral BK</span>
              </div>

              <div class="form-group">
                <label class="form-label">Periode Reset Poin</label>
                <select v-model="system.pointResetPeriod" class="form-select">
                  <option value="semester">Per Semester</option>
                  <option value="annual">Per Tahun Ajaran</option>
                  <option value="never">Tidak Direset</option>
                </select>
              </div>

              <div class="toggle-settings">
                <div class="toggle-item" v-for="toggle in systemToggles" :key="toggle.key">
                  <div class="toggle-info">
                    <p class="toggle-label">{{ toggle.label }}</p>
                    <p class="toggle-desc">{{ toggle.description }}</p>
                  </div>
                  <div class="toggle-switch" :class="{on: system[toggle.key]}" @click="system[toggle.key] = !system[toggle.key]">
                    <div class="toggle-knob"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Notifications -->
          <div v-if="activeTab === 'notifications'" class="card settings-card">
            <div class="card-section-header">
              <h3>Pengaturan Notifikasi</h3>
              <p>Konfigurasi peringatan dan pemberitahuan sistem</p>
            </div>
            <div class="settings-form">
              <div class="toggle-settings">
                <div class="toggle-item" v-for="n in notifToggles" :key="n.key">
                  <div class="toggle-info">
                    <p class="toggle-label">{{ n.label }}</p>
                    <p class="toggle-desc">{{ n.description }}</p>
                  </div>
                  <div class="toggle-switch" :class="{on: notifications[n.key]}" @click="notifications[n.key] = !notifications[n.key]">
                    <div class="toggle-knob"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    <!-- Save Toast -->
    <div v-if="showToast" class="save-toast">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      Pengaturan berhasil disimpan!
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const activeTab = ref('school')
const saving = ref(false)
const showToast = ref(false)

const tabs = [
  { id: 'school', label: 'Sekolah', icon: '<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>' },
  { id: 'system', label: 'Sistem', icon: '<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93l-1.41 1.41M4.93 4.93l1.41 1.41M4.93 19.07l1.41-1.41M19.07 19.07l-1.41-1.41M12 2v2M12 20v2M2 12h2M20 12h2"/></svg>' },
  { id: 'notifications', label: 'Notifikasi', icon: '<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>' },
]

const school = ref({
  name: 'SMA Negeri 1 Contoh',
  npsn: '20100001',
  address: 'Jl. Pendidikan No. 1, Kecamatan Tengah',
  city: 'Jakarta',
  academicYear: '2024/2025',
  phone: '(021) 555-0100',
  email: 'info@sman1contoh.sch.id'
})

const system = ref({
  backupFrequency: 'daily',
  maxPointsBeforeReferral: 50,
  pointResetPeriod: 'semester',
  emailNotifications: true,
  smsNotifications: false,
  autoReferral: true,
})

const notifications = ref({
  newViolation: true,
  referralAlert: true,
  backupStatus: true,
  loginAlert: false,
  weeklyReport: true,
})

const systemToggles = [
  { key: 'emailNotifications', label: 'Notifikasi Email', description: 'Kirim email otomatis untuk pelanggaran baru' },
  { key: 'smsNotifications', label: 'Notifikasi SMS', description: 'Kirim SMS ke orang tua siswa yang melanggar' },
  { key: 'autoReferral', label: 'Referral Otomatis', description: 'Otomatis rujuk siswa ke BK jika melebihi batas poin' },
]

const notifToggles = [
  { key: 'newViolation', label: 'Pelanggaran Baru', description: 'Notifikasi setiap ada pelanggaran baru dicatat' },
  { key: 'referralAlert', label: 'Peringatan Referral', description: 'Notifikasi ketika siswa mendekati batas referral' },
  { key: 'backupStatus', label: 'Status Backup', description: 'Notifikasi hasil backup otomatis' },
  { key: 'loginAlert', label: 'Login Baru', description: 'Notifikasi setiap ada login ke sistem' },
  { key: 'weeklyReport', label: 'Laporan Mingguan', description: 'Kirim ringkasan pelanggaran setiap minggu' },
]

const saveSettings = async () => {
  saving.value = true
  await new Promise(r => setTimeout(r, 1200))
  saving.value = false
  showToast.value = true
  setTimeout(() => { showToast.value = false }, 3000)
}

const resetSettings = () => {
  if (confirm('Reset semua pengaturan ke default?')) {
    alert('Pengaturan direset ke default')
  }
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1100px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.header-actions { display: flex; gap: 8px; }
.settings-layout { display: grid; grid-template-columns: 200px 1fr; gap: 20px; align-items: start; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.settings-nav { padding: 8px; display: flex; flex-direction: column; gap: 2px; position: sticky; top: 24px; }
.nav-item { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 10px; border: none; background: transparent; cursor: pointer; font-size: 13px; font-weight: 500; color: #64748b; transition: all 0.2s; text-align: left; width: 100%; }
.nav-item.active { background: #eff6ff; color: #2563eb; }
.nav-item:hover:not(.active) { background: #f8fafc; }
.nav-icon { display: flex; align-items: center; }
.settings-card { overflow: hidden; }
.card-section-header { padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.card-section-header h3 { font-size: 16px; font-weight: 600; margin: 0 0 4px; }
.card-section-header p { font-size: 13px; color: #64748b; margin: 0; }
.settings-form { padding: 24px; display: flex; flex-direction: column; gap: 20px; }
.logo-upload-area { display: flex; gap: 20px; align-items: center; padding: 20px; background: #f8fafc; border: 2px dashed #e2e8f0; border-radius: 12px; }
.logo-preview { width: 72px; height: 72px; background: #e2e8f0; border-radius: 14px; display: flex; align-items: center; justify-content: center; color: #94a3b8; flex-shrink: 0; }
.upload-info { display: flex; flex-direction: column; gap: 6px; }
.upload-title { font-size: 14px; font-weight: 500; margin: 0; }
.upload-hint { font-size: 12px; color: #94a3b8; margin: 0; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-label { font-size: 13px; font-weight: 500; color: #374151; }
.form-input { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.2s; width: 100%; box-sizing: border-box; resize: vertical; }
.form-input:focus { border-color: #2563eb; }
.form-select { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; }
.form-select:focus { border-color: #2563eb; }
.form-hint { font-size: 12px; color: #94a3b8; }
.input-with-unit { display: flex; align-items: center; gap: 8px; }
.input-with-unit .form-input { flex: 1; }
.unit-label { font-size: 13px; color: #64748b; white-space: nowrap; }
.toggle-settings { display: flex; flex-direction: column; gap: 0; border: 1px solid #f1f5f9; border-radius: 12px; overflow: hidden; }
.toggle-item { display: flex; justify-content: space-between; align-items: center; padding: 16px; border-bottom: 1px solid #f8fafc; }
.toggle-item:last-child { border-bottom: none; }
.toggle-label { font-size: 14px; font-weight: 500; margin: 0; }
.toggle-desc { font-size: 12px; color: #94a3b8; margin: 2px 0 0; }
.toggle-switch { width: 44px; height: 24px; border-radius: 12px; background: #e2e8f0; cursor: pointer; position: relative; transition: background 0.2s; flex-shrink: 0; }
.toggle-switch.on { background: #2563eb; }
.toggle-knob { width: 18px; height: 18px; border-radius: 50%; background: #fff; position: absolute; top: 3px; left: 3px; transition: left 0.2s; box-shadow: 0 1px 4px rgba(0,0,0,0.2); }
.toggle-switch.on .toggle-knob { left: 23px; }
.save-toast { position: fixed; bottom: 24px; right: 24px; background: #16a34a; color: #fff; padding: 12px 20px; border-radius: 12px; font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 8px; box-shadow: 0 8px 30px rgba(0,0,0,0.15); z-index: 9999; animation: slideUp 0.3s ease; }
@keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-primary:disabled { opacity: 0.7; cursor: not-allowed; }
.btn-outline { background: transparent; border: 1px solid #d1d5db; color: #374151; }
.btn-outline:hover { background: #f9fafb; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
</style>
