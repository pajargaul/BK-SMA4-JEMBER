<script setup lang="ts">
import { RouterView } from 'vue-router'
import AppSidebar from '../../components/layout/AppSidebar.vue'

const menuItems = [
  { path: '/guru-bk/dashboard', label: 'Dashboard', icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6', section: 'Utama' },
  { path: '/guru-bk/input-violation', label: 'Input Pelanggaran', icon: 'M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z', section: 'Pelanggaran' },
  { path: '/guru-bk/monitoring', label: 'Monitoring Siswa', icon: 'M15 12a3 3 0 11-6 0 3 3 0 016 0z M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z', section: 'Pelanggaran' },
  { path: '/guru-bk/violation-history', label: 'Riwayat Pelanggaran', icon: 'M4 6h16M4 10h16M4 14h16M4 18h16', section: 'Pelanggaran' },
  { path: '/guru-bk/fuzzy-evaluation', label: 'Evaluasi Fuzzy', icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z', section: 'Evaluasi' },
  { path: '/guru-bk/recommendations', label: 'Rekomendasi', icon: 'M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z', section: 'Evaluasi' },
  { path: '/guru-bk/followup', label: 'Tindak Lanjut', icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z', section: 'Evaluasi' },
  { path: '/guru-bk/reports', label: 'Laporan', icon: 'M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z', section: 'Sistem' },
  { path: '/guru-bk/profile', label: 'Profil', icon: 'M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z', section: 'Akun' },
]
</script>

<template>
  <div class="app-layout">
    <AppSidebar :menu-items="menuItems" />
    <div class="main-content">
      <RouterView />
    </div>
  </div>
</template>
