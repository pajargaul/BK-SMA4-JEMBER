<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../../lib/supabase'

const router = useRouter()
const password = ref('')
const confirm = ref('')
const loading = ref(false)
const done = ref(false)
const error = ref('')

async function handleReset() {
  if (!password.value || !confirm.value) { error.value = 'Semua field harus diisi'; return }
  if (password.value !== confirm.value) { error.value = 'Password tidak cocok'; return }
  if (password.value.length < 6) { error.value = 'Password minimal 6 karakter'; return }
  loading.value = true; error.value = ''
  const { error: err } = await supabase.auth.updateUser({ password: password.value })
  loading.value = false
  if (err) error.value = err.message
  else done.value = true
}
</script>

<template>
  <div class="auth-simple-page">
    <div class="auth-simple-card">
      <div v-if="!done">
        <div class="icon-wrapper">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="28" height="28"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <h1 class="auth-title">Reset Password</h1>
        <p class="auth-subtitle">Masukkan password baru untuk akun Anda</p>
        <div v-if="error" class="alert-error">{{ error }}</div>
        <form @submit.prevent="handleReset" class="auth-form">
          <div class="form-group">
            <label class="form-label">Password Baru</label>
            <input v-model="password" type="password" class="form-input" placeholder="••••••••" required />
          </div>
          <div class="form-group">
            <label class="form-label">Konfirmasi Password</label>
            <input v-model="confirm" type="password" class="form-input" placeholder="••••••••" required />
          </div>
          <button type="submit" class="btn btn-primary w-full" :disabled="loading">
            {{ loading ? 'Menyimpan...' : 'Reset Password' }}
          </button>
        </form>
      </div>
      <div v-else class="success-state">
        <div class="success-icon">🎉</div>
        <h2>Password Berhasil Diubah!</h2>
        <p>Password Anda telah berhasil diperbarui. Silakan login dengan password baru.</p>
        <button class="btn btn-primary w-full" @click="router.push('/login')">Login Sekarang</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-simple-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; background: var(--bg-base); padding: 24px; }
.auth-simple-card { width: 100%; max-width: 420px; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 20px; padding: 40px; box-shadow: var(--shadow-xl); }
.icon-wrapper { width: 64px; height: 64px; background: var(--green-50); border-radius: 16px; display: flex; align-items: center; justify-content: center; color: var(--green-600); margin-bottom: 20px; }
.dark .icon-wrapper { background: rgba(34,197,94,0.15); }
.auth-title { font-size: 1.5rem; font-weight: 800; margin-bottom: 8px; }
.auth-subtitle { font-size: 14px; color: var(--text-muted); margin-bottom: 28px; }
.alert-error { background: var(--red-50); border: 1px solid var(--red-200); color: var(--red-600); padding: 10px 14px; border-radius: 8px; font-size: 13px; margin-bottom: 16px; }
.auth-form { display: flex; flex-direction: column; gap: 16px; }
.success-state { text-align: center; display: flex; flex-direction: column; gap: 16px; align-items: center; }
.success-icon { font-size: 48px; }
.success-state h2 { font-size: 1.5rem; font-weight: 700; }
.success-state p { font-size: 14px; color: var(--text-secondary); line-height: 1.6; }
</style>
