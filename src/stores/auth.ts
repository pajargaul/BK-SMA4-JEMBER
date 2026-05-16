import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '../lib/supabase'
import type { Profile } from '../lib/supabase'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<Profile | null>(null)
  const loading = ref(true)

  const isAdmin = computed(() => user.value?.role === 'admin')
  const isGuruBK = computed(() => user.value?.role === 'guru_bk')
  const isSiswa = computed(() => user.value?.role === 'siswa')
  const isAuthenticated = computed(() => user.value !== null)

  async function fetchProfile() {
    const { data: authUser } = await supabase.auth.getUser()
    if (!authUser.user) { user.value = null; loading.value = false; return }
    const { data } = await supabase.from('profiles').select('*').eq('id', authUser.user.id).maybeSingle()
    user.value = data
    loading.value = false
  }

  async function signIn(email: string, password: string) {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) throw error
    await fetchProfile()
  }

  async function signOut() {
    await supabase.auth.signOut()
    user.value = null
  }

  supabase.auth.onAuthStateChange((event) => {
    if (event === 'SIGNED_OUT') user.value = null
    else if (event === 'SIGNED_IN') {
      (async () => { await fetchProfile() })()
    }
  })

  fetchProfile()

  return { user, loading, isAdmin, isGuruBK, isSiswa, isAuthenticated, signIn, signOut, fetchProfile }
})
