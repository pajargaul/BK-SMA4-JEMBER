<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useThemeStore } from '../../stores/theme'

const props = defineProps<{ menuItems: { path: string; label: string; icon: string; section?: string }[] }>()
const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const theme = useThemeStore()

const grouped = computed(() => {
  const sections: Record<string, typeof props.menuItems> = {}
  for (const item of props.menuItems) {
    const sec = item.section || 'Menu'
    if (!sections[sec]) sections[sec] = []
    sections[sec].push(item)
  }
  return sections
})

function isActive(path: string) { return route.path === path || route.path.startsWith(path + '/') }

const roleLabel = computed(() => {
  if (auth.isAdmin) return 'Administrator'
  if (auth.isGuruBK) return 'Guru BK'
  return 'Siswa'
})
const roleColor = computed(() => auth.isAdmin ? 'primary' : auth.isGuruBK ? 'teal' : 'amber')
</script>

<template>
  <aside class="sidebar">
    <!-- Logo -->
    <div class="sidebar-header">
      <div class="sidebar-logo">
        <div class="logo-icon">
          <svg viewBox="0 0 32 32" fill="none" width="28" height="28">
            <rect width="32" height="32" rx="8" fill="#2563EB"/>
            <path d="M8 22L14 10L20 18L23 14L26 22H8Z" fill="white" opacity="0.9"/>
            <circle cx="16" cy="9" r="3" fill="#14B8A6"/>
          </svg>
        </div>
        <div class="sidebar-logo-text">
          <span class="logo-name">SMAVN4</span>
          <span class="logo-sub">Monitoring</span>
        </div>
      </div>
    </div>

    <!-- User info -->
    <div class="sidebar-user">
      <div class="user-avatar">
        <img v-if="auth.user?.avatar_url" :src="auth.user.avatar_url" alt="avatar" />
        <span v-else>{{ auth.user?.full_name?.charAt(0) || '?' }}</span>
      </div>
      <div class="user-info">
        <div class="user-name">{{ auth.user?.full_name || 'Pengguna' }}</div>
        <div :class="['user-role', roleColor]">{{ roleLabel }}</div>
      </div>
    </div>

    <!-- Nav -->
    <nav class="sidebar-nav">
      <template v-for="(items, section) in grouped" :key="section">
        <div class="nav-section-title">{{ section }}</div>
        <router-link
          v-for="item in items"
          :key="item.path"
          :to="item.path"
          :class="['nav-link', { active: isActive(item.path) }]"
        >
          <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="18" height="18">
            <path :d="item.icon"/>
          </svg>
          <span>{{ item.label }}</span>
          <span v-if="isActive(item.path)" class="nav-dot"></span>
        </router-link>
      </template>
    </nav>

    <!-- Bottom actions -->
    <div class="sidebar-footer">
      <button class="nav-link" @click="theme.toggle()">
        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="18" height="18">
          <path v-if="theme.isDark" d="M12 3v1m0 16v1m8.66-13l-.87.5M4.21 17.5l-.87.5M20.66 17.5l-.87-.5M4.21 6.5l-.87-.5M21 12h-1M4 12H3"/>
          <path v-else d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/>
        </svg>
        <span>{{ theme.isDark ? 'Mode Terang' : 'Mode Gelap' }}</span>
      </button>
      <button class="nav-link logout" @click="auth.signOut().then(() => router.push('/login'))">
        <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" width="18" height="18">
          <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/>
        </svg>
        <span>Keluar</span>
      </button>
    </div>
  </aside>
</template>

<style scoped>
.sidebar-header { padding: 20px 16px; border-bottom: 1px solid var(--border-color); }
.sidebar-logo { display: flex; align-items: center; gap: 10px; }
.logo-icon { flex-shrink: 0; }
.sidebar-logo-text { display: flex; flex-direction: column; line-height: 1.1; }
.logo-name { font-size: 15px; font-weight: 800; color: var(--primary-600); }
.logo-sub { font-size: 10px; color: var(--text-muted); font-weight: 500; }

.sidebar-user { padding: 16px; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; gap: 10px; }
.user-avatar { width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, var(--primary-500), var(--teal-500)); display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; overflow: hidden; flex-shrink: 0; }
.user-avatar img { width: 100%; height: 100%; object-fit: cover; }
.user-info { flex: 1; min-width: 0; }
.user-name { font-size: 13px; font-weight: 600; color: var(--text-primary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.user-role { font-size: 11px; font-weight: 600; padding: 1px 8px; border-radius: 100px; display: inline-block; margin-top: 2px; }
.user-role.primary { background: var(--primary-50); color: var(--primary-600); }
.user-role.teal { background: var(--teal-50); color: var(--teal-600); }
.user-role.amber { background: var(--amber-50); color: var(--amber-600); }
.dark .user-role.primary { background: rgba(37,99,235,0.15); color: var(--primary-400); }
.dark .user-role.teal { background: rgba(20,184,166,0.15); color: var(--teal-400); }
.dark .user-role.amber { background: rgba(245,158,11,0.15); color: var(--amber-400); }

.sidebar-footer { padding: 12px; border-top: 1px solid var(--border-color); }
.nav-link.logout:hover { color: var(--red-500); background: var(--red-50); }
.dark .nav-link.logout:hover { background: rgba(239,68,68,0.1); }

@media (max-width: 1024px) {
  .sidebar-logo-text, .user-info, .nav-link span { display: none; }
  .nav-section-title { display: none; }
  .sidebar-user { justify-content: center; }
  .nav-link { justify-content: center; }
  .nav-dot { display: none; }
}
</style>
