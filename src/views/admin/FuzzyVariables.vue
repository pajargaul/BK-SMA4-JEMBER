<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Variabel Fuzzy'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Variabel Fuzzy</h1>
          <p class="page-subtitle">Konfigurasi variabel input dan output sistem fuzzy</p>
        </div>
      </div>

      <div class="info-banner">
        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        <span>Variabel fuzzy digunakan oleh mesin inferensi untuk menentukan tingkat pelanggaran siswa secara otomatis.</span>
      </div>

      <div class="vars-grid">
        <div v-for="variable in fuzzyVariables" :key="variable.id" class="var-card card">
          <div class="var-header" :style="{borderLeftColor: variable.color}">
            <div class="var-icon" :style="{background: variable.color + '20', color: variable.color}">
              <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path v-if="variable.type==='input'" d="M3 12h18M3 6h12M3 18h12"/>
                <path v-else d="M21 12H3m12-6 6 6-6 6"/>
              </svg>
            </div>
            <div class="var-title">
              <h3>{{ variable.name }}</h3>
              <span :class="variable.type === 'input' ? 'badge badge-primary' : 'badge badge-warning'">
                {{ variable.type === 'input' ? 'Input' : 'Output' }}
              </span>
            </div>
            <button class="btn btn-ghost btn-sm ml-auto" @click="openEditModal(variable)">
              <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
              Edit
            </button>
          </div>

          <div class="var-body">
            <div class="var-range">
              <div class="range-item">
                <span class="range-label">Nilai Minimum</span>
                <span class="range-value">{{ variable.min }}</span>
              </div>
              <div class="range-bar">
                <div class="range-fill" :style="{background: variable.color}"></div>
              </div>
              <div class="range-item">
                <span class="range-label">Nilai Maksimum</span>
                <span class="range-value">{{ variable.max }}</span>
              </div>
            </div>
            <div class="var-meta">
              <div class="meta-item">
                <span class="meta-label">Satuan</span>
                <span class="meta-val">{{ variable.unit }}</span>
              </div>
              <div class="meta-item">
                <span class="meta-label">Fungsi Keanggotaan</span>
                <span class="meta-val">{{ variable.mfCount }} fungsi</span>
              </div>
            </div>
            <div class="mf-tags">
              <span v-for="mf in variable.membershipFunctions" :key="mf.name" class="mf-tag" :style="{background: mf.color + '20', color: mf.color, borderColor: mf.color + '40'}">
                {{ mf.name }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-box">
        <div class="modal-header">
          <h3>Edit Variabel: {{ editingVar?.name }}</h3>
          <button class="btn btn-ghost btn-sm" @click="closeModal">&#10005;</button>
        </div>
        <form @submit.prevent="saveVariable" class="modal-body">
          <div class="form-group">
            <label class="form-label">Nama Variabel</label>
            <input v-model="form.name" type="text" class="form-input" required />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label">Nilai Minimum</label>
              <input v-model.number="form.min" type="number" class="form-input" required />
            </div>
            <div class="form-group">
              <label class="form-label">Nilai Maksimum</label>
              <input v-model.number="form.max" type="number" class="form-input" required />
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Satuan</label>
            <input v-model="form.unit" type="text" class="form-input" placeholder="Contoh: pelanggaran, kali, nilai" />
          </div>
          <div class="form-group">
            <label class="form-label">Tipe</label>
            <div class="type-toggle">
              <button type="button" :class="['toggle-btn', form.type === 'input' ? 'active' : '']" @click="form.type = 'input'">Input</button>
              <button type="button" :class="['toggle-btn', form.type === 'output' ? 'active' : '']" @click="form.type = 'output'">Output</button>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline" @click="closeModal">Batal</button>
            <button type="submit" class="btn btn-primary">Simpan</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const showModal = ref(false)
const editingVar = ref(null)
const form = ref({ name: '', min: 0, max: 50, unit: '', type: 'input' })

const fuzzyVariables = ref([
  {
    id: 1, name: 'Jumlah Pelanggaran', type: 'input', min: 0, max: 50, unit: 'pelanggaran', color: '#2563EB', mfCount: 3,
    membershipFunctions: [{ name: 'Sedikit', color: '#22c55e' }, { name: 'Sedang', color: '#f59e0b' }, { name: 'Banyak', color: '#ef4444' }]
  },
  {
    id: 2, name: 'Frekuensi Pelanggaran', type: 'input', min: 0, max: 12, unit: 'kali/bulan', color: '#14B8A6', mfCount: 3,
    membershipFunctions: [{ name: 'Rendah', color: '#22c55e' }, { name: 'Sedang', color: '#f59e0b' }, { name: 'Tinggi', color: '#ef4444' }]
  },
  {
    id: 3, name: 'Tingkat Keparahan', type: 'input', min: 0, max: 100, unit: 'poin', color: '#F59E0B', mfCount: 3,
    membershipFunctions: [{ name: 'Ringan', color: '#22c55e' }, { name: 'Sedang', color: '#f59e0b' }, { name: 'Berat', color: '#ef4444' }]
  },
  {
    id: 4, name: 'Tingkat Pelanggaran', type: 'output', min: 0, max: 100, unit: 'nilai', color: '#8B5CF6', mfCount: 3,
    membershipFunctions: [{ name: 'Ringan', color: '#22c55e' }, { name: 'Sedang', color: '#f59e0b' }, { name: 'Berat', color: '#ef4444' }]
  },
])

const openEditModal = (v) => {
  editingVar.value = v
  form.value = { name: v.name, min: v.min, max: v.max, unit: v.unit, type: v.type }
  showModal.value = true
}
const closeModal = () => { showModal.value = false }
const saveVariable = () => {
  if (editingVar.value) {
    const idx = fuzzyVariables.value.findIndex(v => v.id === editingVar.value.id)
    if (idx !== -1) fuzzyVariables.value[idx] = { ...fuzzyVariables.value[idx], ...form.value }
  }
  closeModal()
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1200px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
.info-banner { display: flex; align-items: center; gap: 10px; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 12px; padding: 12px 16px; color: #1d4ed8; font-size: 13px; margin-bottom: 24px; }
.vars-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
.var-card { padding: 0; overflow: hidden; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.var-header { display: flex; align-items: center; gap: 12px; padding: 16px 20px; border-bottom: 1px solid #f1f5f9; border-left: 4px solid transparent; }
.var-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.var-title { flex: 1; }
.var-title h3 { font-size: 14px; font-weight: 600; margin: 0 0 4px; }
.ml-auto { margin-left: auto; }
.var-body { padding: 16px 20px; display: flex; flex-direction: column; gap: 16px; }
.var-range { display: flex; align-items: center; gap: 12px; }
.range-item { text-align: center; }
.range-label { display: block; font-size: 11px; color: #94a3b8; margin-bottom: 2px; }
.range-value { font-size: 18px; font-weight: 700; color: var(--text-primary, #1e293b); }
.range-bar { flex: 1; height: 6px; background: #f1f5f9; border-radius: 3px; overflow: hidden; }
.range-fill { height: 100%; width: 100%; border-radius: 3px; opacity: 0.6; }
.var-meta { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.meta-item { background: #f8fafc; border-radius: 10px; padding: 10px; }
.meta-label { display: block; font-size: 11px; color: #94a3b8; margin-bottom: 4px; }
.meta-val { font-size: 13px; font-weight: 600; color: var(--text-primary, #1e293b); }
.mf-tags { display: flex; gap: 8px; flex-wrap: wrap; }
.mf-tag { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 500; border: 1px solid; }
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 16px; width: 100%; max-width: 460px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.modal-header h3 { font-size: 16px; font-weight: 600; }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 8px; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-label { font-size: 13px; font-weight: 500; color: #374151; }
.form-input { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.2s; width: 100%; box-sizing: border-box; }
.form-input:focus { border-color: #2563eb; }
.type-toggle { display: flex; gap: 0; border: 1px solid #d1d5db; border-radius: 10px; overflow: hidden; }
.toggle-btn { flex: 1; padding: 9px; background: transparent; border: none; cursor: pointer; font-size: 14px; font-weight: 500; color: #64748b; transition: all 0.2s; }
.toggle-btn.active { background: #2563eb; color: #fff; }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-outline { background: transparent; border: 1px solid #d1d5db; color: #374151; }
.btn-outline:hover { background: #f9fafb; }
.btn-ghost { background: transparent; color: #64748b; }
.btn-ghost:hover { background: #f1f5f9; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
.badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
.badge-primary { background: #eff6ff; color: #1d4ed8; }
.badge-warning { background: #fffbeb; color: #92400e; }
</style>
