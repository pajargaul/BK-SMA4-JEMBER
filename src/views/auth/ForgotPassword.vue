<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../../lib/supabase'

const router = useRouter()
const email = ref('')
const loading = ref(false)
const sent = ref(false)
const error = ref('')

async function handleSubmit() {
  if (!email.value) { error.value = 'Email harus diisi'; return }
  loading.value = true; error.value = ''
  const { error: err } = await supabase.auth.resetPasswordForEmail(email.value, { redirectTo: `${window.location.origin}/reset-password` })
  loading.value = false
  if (err) error.value = err.message
  else sent.value = true
}
</script>

<template>
  <div class="auth-simple-page">
    <div class="auth-simple-card">
      <button class="back-btn" @click="router.push('/login')">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
        Kembali ke Login
      </button>

      <div v-if="!sent">
        <div class="icon-wrapper">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="28" height="28"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
        </div>
        <h1 class="auth-title">Lupa Password</h1>
        <p class="auth-subtitle">Masukkan email Anda dan kami akan mengirimkan link untuk reset password</p>
        <div v-if="error" class="alert-error">{{ error }}</div>
        <form @submit.prevent="handleSubmit" class="auth-form">
          <div class="form-group">
            <label class="form-label">Email</label>
            <input v-model="email" type="email" class="form-input" placeholder="email@sman4jember.sch.id" required />
          </div>
          <button type="submit" class="btn btn-primary w-full" :disabled="loading">
            {{ loading ? 'Mengirim...' : 'Kirim Link Reset' }}
          </button>
        </form>
      </div>

      <div v-else class="success-state">
        <div class="success-icon">✉️</div>
        <h2>Email Terkirim!</h2>
        <p>Kami telah mengirimkan link reset password ke <strong>{{ email }}</strong>. Periksa inbox Anda.</p>
        <button class="btn btn-primary w-full" @click="router.push('/login')">Kembali ke Login</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-simple-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; background: var(--bg-base); padding: 24px; }
.auth-simple-card { width: 100%; max-width: 420px; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 20px; padding: 40px; box-shadow: var(--shadow-xl); }
.back-btn { display: flex; align-items: center; gap: 8px; background: none; border: none; color: var(--text-secondary); font-size: 13px; cursor: pointer; margin-bottom: 32px; padding: 0; font-family: var(--font-primary); }
.back-btn:hover { color: var(--primary-600); }
.icon-wrapper { width: 64px; height: 64px; background: var(--primary-50); border-radius: 16px; display: flex; align-items: center; justify-content: center; color: var(--primary-600); margin-bottom: 20px; }
.dark .icon-wrapper { background: rgba(37,99,235,0.15); }
.auth-title { font-size: 1.5rem; font-weight: 800; margin-bottom: 8px; }
.auth-subtitle { font-size: 14px; color: var(--text-muted); line-height: 1.6; margin-bottom: 28px; }
.alert-error { background: var(--red-50); border: 1px solid var(--red-200); color: var(--red-600); padding: 10px 14px; border-radius: 8px; font-size: 13px; margin-bottom: 16px; }
.auth-form { display: flex; flex-direction: column; gap: 16px; }
.success-state { text-align: center; display: flex; flex-direction: column; gap: 16px; align-items: center; }
.success-icon { font-size: 48px; }
.success-state h2 { font-size: 1.5rem; font-weight: 700; }
.success-state p { font-size: 14px; color: var(--text-secondary); line-height: 1.6; }
</style>
