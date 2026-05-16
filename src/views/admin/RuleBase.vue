<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Basis Aturan Fuzzy'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Basis Aturan Fuzzy</h1>
          <p class="page-subtitle">Kelola aturan inferensi fuzzy untuk penilaian pelanggaran</p>
        </div>
        <button class="btn btn-primary" @click="openAddModal">+ Tambah Aturan</button>
      </div>

      <div class="info-banner">
        <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0 1 12 2.944a11.955 11.955 0 0 1-8.618 3.04A12.02 12.02 0 0 0 3 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
        <span>Total <strong>{{ rules.length }} aturan</strong> aktif. Aturan diproses menggunakan metode inferensi Mamdani.</span>
      </div>

      <!-- Rules Grid -->
      <div class="rules-grid">
        <div v-for="rule in rules" :key="rule.id" class="rule-card card">
          <div class="rule-number">#{{ rule.id }}</div>
          <div class="rule-body">
            <div class="rule-if-section">
              <span class="rule-keyword if-keyword">IF</span>
              <div class="conditions">
                <div v-for="(cond, i) in rule.conditions" :key="i" class="condition-row">
                  <span class="cond-var">{{ cond.variable }}</span>
                  <span class="cond-is">adalah</span>
                  <span class="cond-val" :style="{background: mfColor(cond.value) + '20', color: mfColor(cond.value), borderColor: mfColor(cond.value) + '40'}">
                    {{ cond.value }}
                  </span>
                  <span v-if="i < rule.conditions.length - 1" class="cond-and">AND</span>
                </div>
              </div>
            </div>
            <div class="rule-then-section">
              <span class="rule-keyword then-keyword">THEN</span>
              <div class="then-result">
                <span class="cond-var">{{ rule.output.variable }}</span>
                <span class="cond-is">adalah</span>
                <span class="result-val" :style="{background: mfColor(rule.output.value) + '20', color: mfColor(rule.output.value)}">
                  {{ rule.output.value }}
                </span>
              </div>
            </div>
          </div>
          <div class="rule-actions">
            <button class="btn btn-ghost btn-sm" @click="openEditModal(rule)">Edit</button>
            <button class="btn btn-ghost btn-sm danger" @click="deleteRule(rule.id)">Hapus</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-box">
        <div class="modal-header">
          <h3>{{ editingRule ? 'Edit Aturan' : 'Tambah Aturan Baru' }}</h3>
          <button class="btn btn-ghost btn-sm" @click="closeModal">&#10005;</button>
        </div>
        <div class="modal-body">
          <div class="section-label">Kondisi (IF)</div>
          <div v-for="(cond, i) in form.conditions" :key="i" class="condition-builder">
            <div class="cond-label">Kondisi {{ i + 1 }}</div>
            <div class="cond-row">
              <select v-model="cond.variable" class="form-select">
                <option value="">Pilih Variabel</option>
                <option v-for="v in inputVars" :key="v.name" :value="v.name">{{ v.name }}</option>
              </select>
              <span class="is-label">adalah</span>
              <select v-model="cond.value" class="form-select">
                <option value="">Pilih Nilai</option>
                <option v-for="val in getVarValues(cond.variable)" :key="val" :value="val">{{ val }}</option>
              </select>
              <button type="button" class="btn btn-ghost btn-sm" @click="removeCondition(i)" v-if="form.conditions.length > 1">✕</button>
            </div>
            <div v-if="i < form.conditions.length - 1" class="and-divider">AND</div>
          </div>
          <button type="button" class="btn btn-outline btn-sm add-cond-btn" @click="addCondition">+ Tambah Kondisi</button>

          <div class="section-label" style="margin-top:20px;">Kesimpulan (THEN)</div>
          <div class="cond-row">
            <select v-model="form.output.variable" class="form-select">
              <option value="Tingkat Pelanggaran">Tingkat Pelanggaran</option>
            </select>
            <span class="is-label">adalah</span>
            <select v-model="form.output.value" class="form-select">
              <option value="">Pilih Nilai</option>
              <option value="Ringan">Ringan</option>
              <option value="Sedang">Sedang</option>
              <option value="Berat">Berat</option>
            </select>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-outline" @click="closeModal">Batal</button>
            <button type="button" class="btn btn-primary" @click="saveRule">{{ editingRule ? 'Simpan' : 'Tambah' }}</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const showModal = ref(false)
const editingRule = ref(null)

const inputVars = [
  { name: 'Jumlah Pelanggaran', values: ['Sedikit', 'Sedang', 'Banyak'] },
  { name: 'Frekuensi Pelanggaran', values: ['Rendah', 'Sedang', 'Tinggi'] },
  { name: 'Tingkat Keparahan', values: ['Ringan', 'Sedang', 'Berat'] },
]

const getVarValues = (varName) => {
  const found = inputVars.find(v => v.name === varName)
  return found ? found.values : []
}

const mfColorMap = {
  Sedikit: '#22c55e', Rendah: '#22c55e', Ringan: '#22c55e',
  Sedang: '#f59e0b',
  Banyak: '#ef4444', Tinggi: '#ef4444', Berat: '#ef4444',
}
const mfColor = (val) => mfColorMap[val] || '#94a3b8'

const defaultForm = () => ({
  conditions: [{ variable: '', value: '' }, { variable: '', value: '' }],
  output: { variable: 'Tingkat Pelanggaran', value: '' }
})

const form = ref(defaultForm())

const rules = ref([
  { id: 1, conditions: [{ variable: 'Jumlah Pelanggaran', value: 'Banyak' }, { variable: 'Frekuensi Pelanggaran', value: 'Tinggi' }], output: { variable: 'Tingkat Pelanggaran', value: 'Berat' } },
  { id: 2, conditions: [{ variable: 'Jumlah Pelanggaran', value: 'Sedang' }, { variable: 'Frekuensi Pelanggaran', value: 'Sedang' }], output: { variable: 'Tingkat Pelanggaran', value: 'Sedang' } },
  { id: 3, conditions: [{ variable: 'Jumlah Pelanggaran', value: 'Sedikit' }, { variable: 'Frekuensi Pelanggaran', value: 'Rendah' }], output: { variable: 'Tingkat Pelanggaran', value: 'Ringan' } },
  { id: 4, conditions: [{ variable: 'Jumlah Pelanggaran', value: 'Banyak' }, { variable: 'Tingkat Keparahan', value: 'Berat' }], output: { variable: 'Tingkat Pelanggaran', value: 'Berat' } },
  { id: 5, conditions: [{ variable: 'Jumlah Pelanggaran', value: 'Sedikit' }, { variable: 'Tingkat Keparahan', value: 'Ringan' }], output: { variable: 'Tingkat Pelanggaran', value: 'Ringan' } },
  { id: 6, conditions: [{ variable: 'Frekuensi Pelanggaran', value: 'Tinggi' }, { variable: 'Tingkat Keparahan', value: 'Sedang' }], output: { variable: 'Tingkat Pelanggaran', value: 'Sedang' } },
])

const openAddModal = () => {
  editingRule.value = null
  form.value = defaultForm()
  showModal.value = true
}
const openEditModal = (rule) => {
  editingRule.value = rule
  form.value = { conditions: rule.conditions.map(c => ({ ...c })), output: { ...rule.output } }
  showModal.value = true
}
const closeModal = () => { showModal.value = false }

const addCondition = () => form.value.conditions.push({ variable: '', value: '' })
const removeCondition = (i) => form.value.conditions.splice(i, 1)

const saveRule = () => {
  if (editingRule.value) {
    const idx = rules.value.findIndex(r => r.id === editingRule.value.id)
    if (idx !== -1) rules.value[idx] = { ...rules.value[idx], conditions: form.value.conditions, output: form.value.output }
  } else {
    rules.value.push({ id: Date.now(), conditions: form.value.conditions, output: form.value.output })
  }
  closeModal()
}
const deleteRule = (id) => {
  if (confirm('Hapus aturan ini?')) rules.value = rules.value.filter(r => r.id !== id)
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1100px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
.info-banner { display: flex; align-items: center; gap: 10px; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; padding: 12px 16px; color: #166534; font-size: 13px; margin-bottom: 24px; }
.rules-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 16px; }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.rule-card { padding: 20px; position: relative; transition: box-shadow 0.2s; }
.rule-card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
.rule-number { position: absolute; top: 16px; right: 16px; background: #f1f5f9; color: #94a3b8; font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 20px; }
.rule-body { display: flex; flex-direction: column; gap: 12px; margin-bottom: 16px; }
.rule-if-section, .rule-then-section { display: flex; gap: 10px; align-items: flex-start; }
.rule-keyword { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 8px; font-size: 11px; font-weight: 700; flex-shrink: 0; margin-top: 2px; }
.if-keyword { background: #eff6ff; color: #2563eb; }
.then-keyword { background: #fef3c7; color: #d97706; }
.conditions { display: flex; flex-direction: column; gap: 6px; flex: 1; }
.condition-row { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.then-result { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.cond-var { font-size: 13px; font-weight: 600; color: #1e293b; }
.cond-is { font-size: 12px; color: #94a3b8; }
.cond-and { font-size: 11px; font-weight: 700; color: #2563eb; background: #eff6ff; padding: 2px 8px; border-radius: 6px; margin-top: 2px; }
.cond-val { padding: 2px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; border: 1px solid; }
.result-val { padding: 3px 12px; border-radius: 20px; font-size: 13px; font-weight: 700; }
.rule-actions { display: flex; gap: 8px; padding-top: 12px; border-top: 1px solid #f1f5f9; }
.btn.danger:hover { background: #fef2f2; color: #ef4444; }

.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 16px; width: 100%; max-width: 560px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); max-height: 90vh; overflow-y: auto; }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.modal-header h3 { font-size: 16px; font-weight: 600; }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 12px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
.section-label { font-size: 12px; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; }
.condition-builder { display: flex; flex-direction: column; gap: 8px; }
.cond-label { font-size: 12px; color: #64748b; }
.cond-row { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.cond-row .form-select { flex: 1; min-width: 120px; }
.is-label { font-size: 12px; color: #94a3b8; white-space: nowrap; }
.and-divider { text-align: center; font-size: 11px; font-weight: 700; color: #2563eb; background: #eff6ff; padding: 3px 12px; border-radius: 8px; display: inline-block; }
.add-cond-btn { align-self: flex-start; }
.form-select { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; }
.form-select:focus { border-color: #2563eb; }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-outline { background: transparent; border: 1px solid #d1d5db; color: #374151; }
.btn-outline:hover { background: #f9fafb; }
.btn-ghost { background: transparent; color: #64748b; }
.btn-ghost:hover { background: #f1f5f9; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
</style>
