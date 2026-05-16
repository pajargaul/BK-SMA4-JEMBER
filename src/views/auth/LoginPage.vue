<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { useThemeStore } from '../../stores/theme'

const router = useRouter()
const auth = useAuthStore()
const theme = useThemeStore()
const email = ref('')
const password = ref('')
const remember = ref(false)
const showPass = ref(false)
const loading = ref(false)
const error = ref('')

async function handleLogin() {
  if (!email.value || !password.value) { error.value = 'Email dan password harus diisi'; return }
  loading.value = true; error.value = ''
  try {
    await auth.signIn(email.value, password.value)
    if (auth.isAdmin) router.push('/admin/dashboard')
    else if (auth.isGuruBK) router.push('/guru-bk/dashboard')
    else router.push('/siswa/dashboard')
  } catch (e: unknown) {
    error.value = (e as Error).message || 'Login gagal. Periksa email dan password Anda.'
  } finally { loading.value = false }
}

function demoLogin(role: string) {
  if (role === 'admin') { email.value = 'admin@sman4jember.sch.id'; password.value = 'admin123' }
  else if (role === 'guru') { email.value = 'guru@sman4jember.sch.id'; password.value = 'guru123' }
  else { email.value = 'siswa@sman4jember.sch.id'; password.value = 'siswa123' }
}
</script>

<template>
  <div class="auth-page">
    <div class="auth-left">
      <div class="auth-left-content">
        <div class="auth-logo">
          <svg viewBox="0 0 40 40" fill="none" width="40" height="40">
            <rect width="40" height="40" rx="12" fill="white" opacity="0.15"/>
            <path d="M10 28L18 12L26 22L30 17L34 28H10Z" fill="white" opacity="0.9"/>
            <circle cx="20" cy="11" r="4" fill="#14B8A6"/>
          </svg>
          <span>SMAVN4 System</span>
        </div>
        <h2 class="auth-left-title">Sistem Monitoring Pelanggaran Berbasis Fuzzy Logic</h2>
        <p class="auth-left-desc">Platform terpadu untuk monitoring, evaluasi, dan penanganan pelanggaran siswa secara efektif dan terdata.</p>
        <div class="auth-features">
          <div v-for="f in ['Monitoring real-time pelanggaran','Evaluasi otomatis Fuzzy Logic','Rekomendasi tindakan BK','Laporan dan statistik lengkap']" :key="f" class="auth-feature">
            <span class="auth-feature-check">✓</span>
            <span>{{ f }}</span>
          </div>
        </div>
        <div class="auth-school-info">
          <div class="school-logo">🏫</div>
          <div>
            <div class="school-name">SMA Negeri 4 Jember</div>
            <div class="school-sub">Jember, Jawa Timur</div>
          </div>
        </div>
      </div>
    </div>
    <div class="auth-right">
      <div class="auth-card">
        <div class="auth-header">
          <button class="btn-theme-toggle" @click="theme.toggle()">
            <svg v-if="theme.isDark" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
            <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
          </button>
        </div>
        <div class="auth-form-header">
          <h1 class="auth-title">Selamat Datang</h1>
          <p class="auth-subtitle">Masuk ke akun Anda untuk melanjutkan</p>
        </div>

        <div v-if="error" class="alert-error">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
          {{ error }}
        </div>

        <form @submit.prevent="handleLogin" class="auth-form">
          <div class="form-group">
            <label class="form-label">Email</label>
            <div class="input-wrapper">
              <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
              <input v-model="email" type="email" class="form-input with-icon" placeholder="email@sman4jember.sch.id" required />
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Password</label>
            <div class="input-wrapper">
              <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
              <input v-model="password" :type="showPass ? 'text' : 'password'" class="form-input with-icon" placeholder="••••••••" required />
              <button type="button" class="pass-toggle" @click="showPass=!showPass">
                <svg v-if="showPass" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
              </button>
            </div>
          </div>
          <div class="form-row">
            <label class="checkbox-label"><input type="checkbox" v-model="remember" /><span>Ingat saya</span></label>
            <router-link to="/forgot-password" class="forgot-link">Lupa password?</router-link>
          </div>
          <button type="submit" class="btn btn-primary w-full" :disabled="loading">
            <span v-if="loading" class="spinner"></span>
            {{ loading ? 'Masuk...' : 'Masuk ke Sistem' }}
          </button>
        </form>

        <div class="demo-section">
          <div class="demo-label">Demo Akun</div>
          <div class="demo-buttons">
            <button class="btn btn-outline btn-sm" @click="demoLogin('admin')">Admin</button>
            <button class="btn btn-outline btn-sm" @click="demoLogin('guru')">Guru BK</button>
            <button class="btn btn-outline btn-sm" @click="demoLogin('siswa')">Siswa</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-page { min-height: 100vh; display: grid; grid-template-columns: 1fr 1fr; }
.auth-left {
  background: linear-gradient(135deg, #1E3A8A 0%, #2563EB 50%, #0D9488 100%);
  display: flex; align-items: center; justify-content: center; padding: 48px;
}
.auth-left-content { max-width: 400px; color: white; }
.auth-logo { display: flex; align-items: center; gap: 12px; font-size: 18px; font-weight: 700; margin-bottom: 40px; }
.auth-left-title { font-size: 1.75rem; font-weight: 800; line-height: 1.3; margin-bottom: 16px; }
.auth-left-desc { font-size: 15px; opacity: 0.85; line-height: 1.7; margin-bottom: 32px; }
.auth-features { display: flex; flex-direction: column; gap: 12px; margin-bottom: 40px; }
.auth-feature { display: flex; align-items: center; gap: 12px; font-size: 14px; opacity: 0.9; }
.auth-feature-check { width: 20px; height: 20px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; flex-shrink: 0; }
.auth-school-info { display: flex; align-items: center; gap: 12px; background: rgba(255,255,255,0.1); border-radius: 12px; padding: 16px; }
.school-logo { font-size: 28px; }
.school-name { font-size: 15px; font-weight: 700; }
.school-sub { font-size: 12px; opacity: 0.75; }

.auth-right { display: flex; align-items: center; justify-content: center; padding: 48px; background: var(--bg-base); }
.auth-card { width: 100%; max-width: 420px; }
.auth-header { display: flex; justify-content: flex-end; margin-bottom: 24px; }
.btn-theme-toggle { width: 36px; height: 36px; border-radius: 8px; border: 1.5px solid var(--border-color); background: var(--bg-surface); color: var(--text-secondary); display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; }
.auth-form-header { margin-bottom: 32px; }
.auth-title { font-size: 1.75rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px; }
.auth-subtitle { font-size: 14px; color: var(--text-muted); }
.alert-error { display: flex; align-items: center; gap: 8px; background: var(--red-50); border: 1px solid var(--red-200); color: var(--red-600); padding: 12px 16px; border-radius: 10px; font-size: 13px; margin-bottom: 20px; }
.dark .alert-error { background: rgba(239,68,68,0.1); border-color: rgba(239,68,68,0.3); }
.auth-form { display: flex; flex-direction: column; gap: 20px; margin-bottom: 28px; }
.input-wrapper { position: relative; }
.input-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
.form-input.with-icon { padding-left: 40px; }
.pass-toggle { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: var(--text-muted); padding: 0; display: flex; }
.form-row { display: flex; align-items: center; justify-content: space-between; }
.checkbox-label { display: flex; align-items: center; gap: 8px; font-size: 13px; color: var(--text-secondary); cursor: pointer; }
.checkbox-label input { accent-color: var(--primary-600); }
.forgot-link { font-size: 13px; color: var(--primary-600); font-weight: 500; text-decoration: none; }
.forgot-link:hover { text-decoration: underline; }
.spinner { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.3); border-top-color: white; border-radius: 50%; animation: spin 0.8s linear infinite; flex-shrink: 0; }
.demo-section { border-top: 1px solid var(--border-color); padding-top: 20px; }
.demo-label { font-size: 12px; color: var(--text-muted); text-align: center; margin-bottom: 12px; }
.demo-buttons { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }

@media (max-width: 768px) {
  .auth-page { grid-template-columns: 1fr; }
  .auth-left { display: none; }
}
</style>
