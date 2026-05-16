<script setup lang="ts">
import { ref, computed } from 'vue'

const props = defineProps<{
  breadcrumbs?: { label: string; path?: string }[]
}>()

const showNotif = ref(false)
const search = ref('')

const pageTitle = computed(() => props.breadcrumbs?.at(-1)?.label || 'Dashboard')
</script>

<template>
  <header class="topbar">
    <div class="topbar-left">
      <div class="breadcrumb" v-if="breadcrumbs && breadcrumbs.length > 1">
        <template v-for="(crumb, i) in breadcrumbs" :key="i">
          <span v-if="i > 0" class="breadcrumb-separator">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="12" height="12"><path d="M9 18l6-6-6-6"/></svg>
          </span>
          <span :class="['breadcrumb-item', { last: i === breadcrumbs.length - 1 }]">{{ crumb.label }}</span>
        </template>
      </div>
      <h2 class="topbar-title">{{ pageTitle }}</h2>
    </div>
    <div class="topbar-right">
      <div class="search-box topbar-search">
        <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input v-model="search" type="text" class="form-input" placeholder="Cari..." />
      </div>
      <div class="topbar-actions">
        <div class="notif-wrapper">
          <button class="icon-btn" @click="showNotif = !showNotif">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 01-3.46 0"/></svg>
            <span class="notif-badge">3</span>
          </button>
          <div v-if="showNotif" class="notif-dropdown">
            <div class="notif-header">
              <span>Notifikasi</span>
              <span class="notif-count">3 baru</span>
            </div>
            <div v-for="n in [
              { type: 'danger', title: 'Siswa Prioritas BK', desc: 'Andi Setiawan memerlukan perhatian segera', time: '5 menit lalu' },
              { type: 'warning', title: 'Pelanggaran Baru', desc: '3 pelanggaran baru hari ini', time: '1 jam lalu' },
              { type: 'info', title: 'Laporan Tersedia', desc: 'Laporan bulan ini sudah siap', time: '2 jam lalu' },
            ]" :key="n.title" :class="['notif-item', n.type]">
              <div class="notif-dot" :class="n.type"></div>
              <div class="notif-body">
                <div class="notif-title">{{ n.title }}</div>
                <div class="notif-desc">{{ n.desc }}</div>
                <div class="notif-time">{{ n.time }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<style scoped>
.topbar { height: var(--topbar-height); background: var(--bg-surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 24px; position: sticky; top: 0; z-index: 40; }
.topbar-left { display: flex; flex-direction: column; gap: 2px; }
.topbar-title { font-size: 16px; font-weight: 700; color: var(--text-primary); line-height: 1.2; }
.breadcrumb { display: flex; align-items: center; gap: 4px; }
.breadcrumb-item { font-size: 11px; color: var(--text-muted); }
.breadcrumb-item.last { color: var(--primary-600); font-weight: 500; }
.breadcrumb-separator { color: var(--text-muted); display: flex; }
.topbar-right { display: flex; align-items: center; gap: 12px; }
.topbar-search { min-width: 220px; }
.topbar-search .form-input { padding: 8px 12px 8px 36px; height: 36px; font-size: 13px; border-radius: 8px; }
.topbar-actions { display: flex; gap: 6px; }
.icon-btn { width: 36px; height: 36px; border-radius: 8px; border: 1.5px solid var(--border-color); background: var(--bg-surface); color: var(--text-secondary); display: flex; align-items: center; justify-content: center; cursor: pointer; position: relative; transition: all 0.2s; }
.icon-btn:hover { border-color: var(--primary-400); color: var(--primary-600); }
.notif-badge { position: absolute; top: -4px; right: -4px; width: 16px; height: 16px; border-radius: 50%; background: var(--red-500); color: white; font-size: 9px; font-weight: 700; display: flex; align-items: center; justify-content: center; border: 2px solid var(--bg-surface); }
.notif-wrapper { position: relative; }
.notif-dropdown { position: absolute; top: calc(100% + 8px); right: 0; width: 320px; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: var(--shadow-xl); z-index: 60; overflow: hidden; }
.notif-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; border-bottom: 1px solid var(--border-color); font-size: 13px; font-weight: 600; }
.notif-count { font-size: 11px; background: var(--primary-50); color: var(--primary-600); padding: 2px 8px; border-radius: 100px; }
.notif-item { display: flex; gap: 12px; padding: 14px 16px; cursor: pointer; transition: background 0.15s; }
.notif-item:hover { background: var(--gray-50); }
.dark .notif-item:hover { background: var(--bg-elevated); }
.notif-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; margin-top: 5px; }
.notif-dot.danger { background: var(--red-500); }
.notif-dot.warning { background: var(--amber-500); }
.notif-dot.info { background: var(--primary-500); }
.notif-body { flex: 1; }
.notif-title { font-size: 13px; font-weight: 600; color: var(--text-primary); margin-bottom: 2px; }
.notif-desc { font-size: 12px; color: var(--text-secondary); }
.notif-time { font-size: 11px; color: var(--text-muted); margin-top: 4px; }

@media (max-width: 768px) {
  .topbar-search { display: none; }
}
</style>
