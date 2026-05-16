<script setup lang="ts">
import { RouterView } from 'vue-router'
import AppSidebar from '../../components/layout/AppSidebar.vue'

const menuItems = [
  { path: '/siswa/dashboard', label: 'Dashboard', icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6', section: 'Utama' },
  { path: '/siswa/violations', label: 'Riwayat Pelanggaran', icon: 'M4 6h16M4 10h16M4 14h16M4 18h16', section: 'Informasi' },
  { path: '/siswa/evaluation', label: 'Status Evaluasi', icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z', section: 'Informasi' },
  { path: '/siswa/followup', label: 'Riwayat Tindak Lanjut', icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z', section: 'Informasi' },
  { path: '/siswa/profile', label: 'Profil', icon: 'M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z', section: 'Akun' },
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
