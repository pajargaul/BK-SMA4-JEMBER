<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Database'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Manajemen Database</h1>
          <p class="page-subtitle">Backup, restore, dan export data sistem</p>
        </div>
      </div>

      <!-- Action Cards -->
      <div class="action-cards">
        <!-- Backup -->
        <div class="action-card card">
          <div class="action-icon backup-icon">
            <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
              <polyline points="17 8 12 3 7 8"/>
              <line x1="12" y1="3" x2="12" y2="15"/>
            </svg>
          </div>
          <div class="action-content">
            <h3>Backup Database</h3>
            <p>Buat salinan cadangan database secara lengkap. Backup akan disimpan dengan timestamp otomatis.</p>
            <ul class="action-features">
              <li>Backup otomatis terjadwal</li>
              <li>Enkripsi data tersedia</li>
              <li>Kompresi file otomatis</li>
            </ul>
          </div>
          <div class="action-footer">
            <span class="action-meta">Terakhir backup: <strong>Hari ini, 02:00</strong></span>
            <button class="btn backup-btn" @click="doBackup" :disabled="backupLoading">
              <svg v-if="backupLoading" class="spin" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
              {{ backupLoading ? 'Memproses...' : 'Backup Sekarang' }}
            </button>
          </div>
        </div>

        <!-- Restore -->
        <div class="action-card card">
          <div class="action-icon restore-icon">
            <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
              <polyline points="7 10 12 15 17 10"/>
              <line x1="12" y1="15" x2="12" y2="3"/>
            </svg>
          </div>
          <div class="action-content">
            <h3>Restore Database</h3>
            <p>Pulihkan database dari file backup yang tersimpan. Proses ini akan menimpa data saat ini.</p>
            <div class="warning-box">
              <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/></svg>
              Tindakan ini tidak dapat dibatalkan. Pastikan Anda telah backup terlebih dahulu.
            </div>
          </div>
          <div class="action-footer">
            <span class="action-meta">Pilih file backup (.sql)</span>
            <button class="btn restore-btn" @click="doRestore">Pilih File & Restore</button>
          </div>
        </div>

        <!-- Export -->
        <div class="action-card card">
          <div class="action-icon export-icon">
            <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
              <polyline points="14 2 14 8 20 8"/>
              <line x1="16" y1="13" x2="8" y2="13"/>
              <line x1="16" y1="17" x2="8" y2="17"/>
              <polyline points="10 9 9 9 8 9"/>
            </svg>
          </div>
          <div class="action-content">
            <h3>Export Data</h3>
            <p>Ekspor data sistem ke berbagai format file untuk analisis atau arsip eksternal.</p>
            <div class="export-formats">
              <span v-for="fmt in ['CSV', 'Excel', 'JSON', 'PDF']" :key="fmt" class="format-badge">{{ fmt }}</span>
            </div>
          </div>
          <div class="action-footer">
            <span class="action-meta">Pilih format ekspor</span>
            <button class="btn export-btn" @click="doExport">Export Data</button>
          </div>
        </div>
      </div>

      <!-- Backup History -->
      <div class="card">
        <div class="section-header">
          <h3>Riwayat Backup</h3>
          <span class="badge badge-success">{{ backupHistory.filter(b => b.status === 'success').length }} Berhasil</span>
        </div>
        <table>
          <thead>
            <tr>
              <th>Nama File</th>
              <th>Tanggal & Waktu</th>
              <th>Ukuran</th>
              <th>Tipe</th>
              <th>Status</th>
              <th>Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="backup in backupHistory" :key="backup.id">
              <td>
                <div class="file-cell">
                  <div class="file-icon">
                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                  </div>
                  <span class="file-name">{{ backup.filename }}</span>
                </div>
              </td>
              <td class="text-muted">{{ backup.datetime }}</td>
              <td class="text-muted">{{ backup.size }}</td>
              <td>
                <span :class="backup.type === 'otomatis' ? 'badge badge-primary' : 'badge badge-success'">
                  {{ backup.type === 'otomatis' ? 'Otomatis' : 'Manual' }}
                </span>
              </td>
              <td>
                <span :class="backup.status === 'success' ? 'badge badge-success' : 'badge badge-danger'">
                  {{ backup.status === 'success' ? 'Berhasil' : 'Gagal' }}
                </span>
              </td>
              <td>
                <div class="action-btns">
                  <button class="btn btn-outline btn-sm" @click="downloadBackup(backup)">Unduh</button>
                  <button class="btn btn-ghost btn-sm" @click="deleteBackup(backup.id)">Hapus</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const backupLoading = ref(false)

const doBackup = async () => {
  backupLoading.value = true
  await new Promise(r => setTimeout(r, 2000))
  backupHistory.value.unshift({
    id: Date.now(),
    filename: `backup_${new Date().toISOString().slice(0,10)}_manual.sql`,
    datetime: new Date().toLocaleString('id-ID'),
    size: '4.2 MB',
    type: 'manual',
    status: 'success'
  })
  backupLoading.value = false
  alert('Backup berhasil dibuat!')
}

const doRestore = () => alert('Fitur restore: silakan pilih file backup .sql')
const doExport = () => alert('Memilih format dan mengekspor data...')
const downloadBackup = (b) => alert(`Mengunduh ${b.filename}`)
const deleteBackup = (id) => {
  if (confirm('Hapus file backup ini?')) backupHistory.value = backupHistory.value.filter(b => b.id !== id)
}

const backupHistory = ref([
  { id: 1, filename: 'backup_2025-05-15_auto.sql', datetime: '15 Mei 2025, 02:00', size: '4.1 MB', type: 'otomatis', status: 'success' },
  { id: 2, filename: 'backup_2025-05-14_auto.sql', datetime: '14 Mei 2025, 02:00', size: '4.0 MB', type: 'otomatis', status: 'success' },
  { id: 3, filename: 'backup_2025-05-13_manual.sql', datetime: '13 Mei 2025, 14:32', size: '3.9 MB', type: 'manual', status: 'success' },
  { id: 4, filename: 'backup_2025-05-12_auto.sql', datetime: '12 Mei 2025, 02:00', size: '3.8 MB', type: 'otomatis', status: 'success' },
  { id: 5, filename: 'backup_2025-05-11_auto.sql', datetime: '11 Mei 2025, 02:00', size: '3.8 MB', type: 'otomatis', status: 'failed' },
])
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1200px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.action-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 24px; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.action-card { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.action-icon { width: 64px; height: 64px; border-radius: 18px; display: flex; align-items: center; justify-content: center; }
.backup-icon { background: #dcfce7; color: #16a34a; }
.restore-icon { background: #fffbeb; color: #d97706; }
.export-icon { background: #eff6ff; color: #2563eb; }
.action-content { flex: 1; }
.action-content h3 { font-size: 16px; font-weight: 600; margin: 0 0 8px; }
.action-content p { font-size: 13px; color: #64748b; margin: 0 0 12px; line-height: 1.6; }
.action-features { font-size: 12px; color: #64748b; padding-left: 16px; margin: 0; line-height: 1.8; }
.warning-box { display: flex; align-items: flex-start; gap: 8px; background: #fffbeb; border: 1px solid #fde68a; border-radius: 10px; padding: 10px; font-size: 12px; color: #92400e; line-height: 1.5; }
.export-formats { display: flex; gap: 6px; flex-wrap: wrap; }
.format-badge { background: #eff6ff; color: #2563eb; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.action-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 16px; border-top: 1px solid #f1f5f9; }
.action-meta { font-size: 12px; color: #94a3b8; }
.backup-btn { background: #16a34a; color: #fff; padding: 9px 20px; border-radius: 10px; border: none; cursor: pointer; font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 8px; transition: background 0.2s; }
.backup-btn:hover { background: #15803d; }
.backup-btn:disabled { opacity: 0.7; cursor: not-allowed; }
.restore-btn { background: #d97706; color: #fff; padding: 9px 20px; border-radius: 10px; border: none; cursor: pointer; font-size: 14px; font-weight: 500; transition: background 0.2s; }
.restore-btn:hover { background: #b45309; }
.export-btn { background: #2563eb; color: #fff; padding: 9px 20px; border-radius: 10px; border: none; cursor: pointer; font-size: 14px; font-weight: 500; transition: background 0.2s; }
.export-btn:hover { background: #1d4ed8; }
.section-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid #f1f5f9; }
.section-header h3 { font-size: 14px; font-weight: 600; margin: 0; }
table { width: 100%; border-collapse: collapse; }
th { padding: 12px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #f1f5f9; }
td { padding: 14px 16px; font-size: 14px; border-bottom: 1px solid #f8fafc; vertical-align: middle; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: #f8fafc; }
.file-cell { display: flex; align-items: center; gap: 10px; }
.file-icon { width: 32px; height: 32px; background: #f1f5f9; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #64748b; flex-shrink: 0; }
.file-name { font-size: 13px; font-family: 'Courier New', monospace; color: #374151; }
.text-muted { color: #64748b; }
.action-btns { display: flex; gap: 8px; }
.spin { animation: spin 1s linear infinite; }
@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-outline { background: transparent; border: 1px solid #d1d5db; color: #374151; }
.btn-outline:hover { background: #f9fafb; }
.btn-ghost { background: transparent; color: #64748b; }
.btn-ghost:hover { background: #f1f5f9; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.badge-success { background: #dcfce7; color: #166534; }
.badge-danger { background: #fef2f2; color: #991b1b; }
.badge-primary { background: #eff6ff; color: #1d4ed8; }
@media (max-width: 900px) { .action-cards { grid-template-columns: 1fr; } }
</style>
