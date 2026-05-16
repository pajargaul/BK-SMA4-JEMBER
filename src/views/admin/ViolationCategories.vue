<template>
  <div class="page-wrapper">
    <AppTopbar :breadcrumbs="[{label:'Admin'},{label:'Kategori Pelanggaran'}]" />

    <div class="page-content animate-fade-in">
      <div class="page-header">
        <div>
          <h1 class="page-title">Kategori Pelanggaran</h1>
          <p class="page-subtitle">Kelola kategori jenis pelanggaran siswa</p>
        </div>
        <button class="btn btn-primary" @click="openAddModal">+ Tambah Kategori</button>
      </div>

      <div class="categories-grid">
        <div v-for="cat in categories" :key="cat.id" class="category-card card">
          <div class="card-top">
            <div class="cat-icon" :style="{background: cat.color + '20', color: cat.color}">
              <span class="icon-emoji">{{ cat.icon }}</span>
            </div>
            <div class="cat-actions">
              <button class="btn btn-ghost btn-sm icon-btn" @click="openEditModal(cat)" title="Edit">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
              </button>
              <button class="btn btn-ghost btn-sm icon-btn danger" @click="deleteCategory(cat.id)" title="Hapus">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/></svg>
              </button>
            </div>
          </div>
          <h3 class="cat-name">{{ cat.name }}</h3>
          <p class="cat-desc">{{ cat.description }}</p>
          <div class="cat-footer">
            <div class="violation-count">
              <span class="count-num">{{ cat.count }}</span>
              <span class="count-label">Jenis Pelanggaran</span>
            </div>
            <div class="color-dot" :style="{background: cat.color}"></div>
          </div>
        </div>

        <!-- Add Card -->
        <div class="category-card card add-card" @click="openAddModal">
          <div class="add-icon">+</div>
          <p>Tambah Kategori Baru</p>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-box">
        <div class="modal-header">
          <h3>{{ editingCat ? 'Edit Kategori' : 'Tambah Kategori Baru' }}</h3>
          <button class="btn btn-ghost btn-sm" @click="closeModal">&#10005;</button>
        </div>
        <form @submit.prevent="saveCategory" class="modal-body">
          <div class="form-group">
            <label class="form-label">Nama Kategori</label>
            <input v-model="form.name" type="text" class="form-input" placeholder="Contoh: Kedisiplinan" required />
          </div>
          <div class="form-group">
            <label class="form-label">Deskripsi</label>
            <textarea v-model="form.description" class="form-input" rows="3" placeholder="Deskripsi singkat kategori..."></textarea>
          </div>
          <div class="form-group">
            <label class="form-label">Ikon</label>
            <div class="icon-grid">
              <button
                v-for="icon in iconOptions" :key="icon"
                type="button"
                class="icon-option"
                :class="{selected: form.icon === icon}"
                @click="form.icon = icon"
              >{{ icon }}</button>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Warna</label>
            <div class="color-grid">
              <button
                v-for="color in colorOptions" :key="color"
                type="button"
                class="color-option"
                :class="{selected: form.color === color}"
                :style="{background: color}"
                @click="form.color = color"
              ></button>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline" @click="closeModal">Batal</button>
            <button type="submit" class="btn btn-primary">{{ editingCat ? 'Simpan' : 'Tambah' }}</button>
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
const editingCat = ref(null)
const form = ref({ name: '', description: '', color: '#2563EB', icon: '📋' })

const iconOptions = ['📋','⚠️','🚫','📚','👕','🏃','📱','💬','🤝','⏰','🔇','🎯']
const colorOptions = ['#2563EB','#14B8A6','#F59E0B','#EF4444','#8B5CF6','#EC4899']

const categories = ref([
  { id: 1, name: 'Kedisiplinan', description: 'Pelanggaran terkait kedisiplinan waktu dan aturan sekolah', color: '#2563EB', icon: '⏰', count: 8 },
  { id: 2, name: 'Akademik', description: 'Pelanggaran yang berkaitan dengan kegiatan akademik', color: '#14B8A6', icon: '📚', count: 5 },
  { id: 3, name: 'Penampilan', description: 'Pelanggaran terkait seragam dan penampilan siswa', color: '#F59E0B', icon: '👕', count: 6 },
  { id: 4, name: 'Perilaku', description: 'Pelanggaran terkait perilaku dan etika siswa', color: '#EF4444', icon: '⚠️', count: 10 },
  { id: 5, name: 'Teknologi', description: 'Pelanggaran penggunaan perangkat teknologi di sekolah', color: '#8B5CF6', icon: '📱', count: 3 },
  { id: 6, name: 'Sosial', description: 'Pelanggaran interaksi sosial antar siswa dan guru', color: '#EC4899', icon: '🤝', count: 4 },
])

const openAddModal = () => {
  editingCat.value = null
  form.value = { name: '', description: '', color: '#2563EB', icon: '📋' }
  showModal.value = true
}
const openEditModal = (cat) => {
  editingCat.value = cat
  form.value = { ...cat }
  showModal.value = true
}
const closeModal = () => { showModal.value = false }
const saveCategory = () => {
  if (editingCat.value) {
    const idx = categories.value.findIndex(c => c.id === editingCat.value.id)
    if (idx !== -1) categories.value[idx] = { ...categories.value[idx], ...form.value }
  } else {
    categories.value.push({ id: Date.now(), ...form.value, count: 0 })
  }
  closeModal()
}
const deleteCategory = (id) => {
  if (confirm('Hapus kategori ini?')) categories.value = categories.value.filter(c => c.id !== id)
}
</script>

<style scoped>
.page-wrapper { min-height: 100vh; background: var(--bg-surface, #f8fafc); }
.page-content { padding: 24px; max-width: 1200px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
.categories-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 16px; }
.category-card { padding: 20px; transition: box-shadow 0.2s, transform 0.2s; }
.category-card:hover { box-shadow: 0 6px 24px rgba(0,0,0,0.08); transform: translateY(-2px); }
.card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color, #e2e8f0); }
.card-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px; }
.cat-icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; }
.icon-emoji { font-size: 22px; }
.cat-actions { display: flex; gap: 4px; }
.icon-btn { padding: 6px; border-radius: 8px; }
.icon-btn.danger:hover { background: #fef2f2; color: #ef4444; }
.cat-name { font-size: 16px; font-weight: 600; color: var(--text-primary, #1e293b); margin: 0 0 6px; }
.cat-desc { font-size: 13px; color: #64748b; margin: 0 0 16px; line-height: 1.5; }
.cat-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 16px; border-top: 1px solid #f1f5f9; }
.violation-count { display: flex; flex-direction: column; }
.count-num { font-size: 20px; font-weight: 700; color: var(--text-primary, #1e293b); }
.count-label { font-size: 11px; color: #94a3b8; }
.color-dot { width: 14px; height: 14px; border-radius: 50%; }
.add-card { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 12px; cursor: pointer; border: 2px dashed #d1d5db; background: #fafbfc; color: #94a3b8; min-height: 200px; transition: all 0.2s; }
.add-card:hover { border-color: #2563eb; color: #2563eb; background: #eff6ff; transform: translateY(-2px); }
.add-icon { width: 44px; height: 44px; border-radius: 50%; border: 2px dashed currentColor; display: flex; align-items: center; justify-content: center; font-size: 22px; }
.add-card p { font-size: 14px; font-weight: 500; margin: 0; }

.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 16px; width: 100%; max-width: 480px; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
.modal-header h3 { font-size: 16px; font-weight: 600; }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 8px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-label { font-size: 13px; font-weight: 500; color: #374151; }
.form-input { padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 10px; font-size: 14px; outline: none; transition: border-color 0.2s; width: 100%; box-sizing: border-box; resize: vertical; }
.form-input:focus { border-color: #2563eb; }
.icon-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 8px; }
.icon-option { padding: 8px; border: 2px solid transparent; border-radius: 10px; background: #f8fafc; cursor: pointer; font-size: 18px; transition: all 0.2s; }
.icon-option:hover { background: #eff6ff; border-color: #bfdbfe; }
.icon-option.selected { border-color: #2563eb; background: #eff6ff; }
.color-grid { display: flex; gap: 10px; flex-wrap: wrap; }
.color-option { width: 32px; height: 32px; border-radius: 50%; border: 3px solid transparent; cursor: pointer; transition: transform 0.2s; outline: none; }
.color-option:hover { transform: scale(1.15); }
.color-option.selected { border-color: #1e293b; transform: scale(1.15); }
.btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; }
.btn-outline { background: transparent; border: 1px solid #d1d5db; color: #374151; }
.btn-outline:hover { background: #f9fafb; }
.btn-ghost { background: transparent; color: #64748b; }
.btn-ghost:hover { background: #f1f5f9; }
.btn-sm { padding: 5px 12px; font-size: 12px; }
</style>
