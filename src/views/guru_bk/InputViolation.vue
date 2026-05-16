<script setup lang="ts">
import { ref, computed } from 'vue'
import AppTopbar from '../../components/layout/AppTopbar.vue'

const breadcrumbs = [{ label: 'Guru BK' }, { label: 'Input Pelanggaran' }]

const studentSearch = ref('')
const selectedStudent = ref<{ name: string; class: string } | null>(null)
const showDropdown = ref(false)
const violationType = ref('')
const severity = ref('Ringan')
const description = ref('')
const date = ref(new Date().toISOString().split('T')[0])
const isDragging = ref(false)

const students = [
  { name: 'Ahmad Rizky', class: 'XI IPA 2' },
  { name: 'Budi Santoso', class: 'X IPS 1' },
  { name: 'Citra Dewi', class: 'XII IPA 1' },
  { name: 'Dian Pratama', class: 'XI IPS 3' },
  { name: 'Eko Wijaya', class: 'X IPA 3' },
  { name: 'Fajar Nugroho', class: 'XII IPS 2' },
  { name: 'Gita Sari', class: 'XI IPA 1' },
]

const violationTypes = [
  'Terlambat masuk sekolah',
  'Tidak mengerjakan PR',
  'Membolos pelajaran',
  'Berpakaian tidak sesuai',
  'Berkelahi',
  'Membawa HP saat ujian',
  'Vandalism',
  'Lainnya',
]

const filteredStudents = computed(() =>
  students.filter(s => s.name.toLowerCase().includes(studentSearch.value.toLowerCase()))
)

function selectStudent(s: { name: string; class: string }) {
  selectedStudent.value = s
  studentSearch.value = s.name
  showDropdown.value = false
}

function onStudentInput() {
  showDropdown.value = true
  selectedStudent.value = null
}

const recentSubmissions = ref([
  { student: 'Ahmad Rizky', class: 'XI IPA 2', type: 'Membolos pelajaran', severity: 'Sedang', date: '15/05/2026' },
  { student: 'Budi Santoso', class: 'X IPS 1', type: 'Terlambat masuk sekolah', severity: 'Ringan', date: '15/05/2026' },
  { student: 'Citra Dewi', class: 'XII IPA 1', type: 'Tidak mengerjakan PR', severity: 'Ringan', date: '14/05/2026' },
  { student: 'Dian Pratama', class: 'XI IPS 3', type: 'Berkelahi', severity: 'Berat', date: '13/05/2026' },
  { student: 'Eko Wijaya', class: 'X IPA 3', type: 'Berpakaian tidak sesuai', severity: 'Ringan', date: '12/05/2026' },
])

function getSeverityBadge(sev: string) {
  if (sev === 'Berat') return 'badge-danger'
  if (sev === 'Sedang') return 'badge-warning'
  return 'badge-success'
}

function handleSubmit() {
  if (!selectedStudent.value || !violationType.value) return
  recentSubmissions.value.unshift({
    student: selectedStudent.value.name,
    class: selectedStudent.value.class,
    type: violationType.value,
    severity: severity.value,
    date: date.value.split('-').reverse().join('/'),
  })
  recentSubmissions.value = recentSubmissions.value.slice(0, 5)
  studentSearch.value = ''
  selectedStudent.value = null
  violationType.value = ''
  severity.value = 'Ringan'
  description.value = ''
  date.value = new Date().toISOString().split('T')[0]
}

function handleCancel() {
  studentSearch.value = ''
  selectedStudent.value = null
  violationType.value = ''
  severity.value = 'Ringan'
  description.value = ''
}
</script>

<template>
  <div class="page-container animate-fade-in">
    <AppTopbar :breadcrumbs="breadcrumbs" />

    <div class="page-content">
      <div class="page-header">
        <h1 class="page-title">Input Pelanggaran</h1>
        <p class="page-subtitle">Catat pelanggaran siswa secara lengkap dan akurat.</p>
      </div>

      <div class="content-grid">
        <!-- Form -->
        <div class="card form-section">
          <h3 class="section-title">Data Pelanggaran Baru</h3>

          <form @submit.prevent="handleSubmit">
            <!-- Student Search -->
            <div class="form-group student-search-wrap">
              <label class="form-label">Siswa <span class="required">*</span></label>
              <div class="student-input-wrap" v-click-outside="() => (showDropdown = false)">
                <input
                  v-model="studentSearch"
                  @input="onStudentInput"
                  @focus="showDropdown = true"
                  class="form-input"
                  placeholder="Cari nama siswa..."
                  autocomplete="off"
                />
                <div v-if="showDropdown && filteredStudents.length" class="student-dropdown">
                  <div
                    v-for="s in filteredStudents"
                    :key="s.name"
                    class="student-option"
                    @mousedown.prevent="selectStudent(s)"
                  >
                    <div class="option-name">{{ s.name }}</div>
                    <div class="option-class">{{ s.class }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Class (auto-filled) -->
            <div class="form-group">
              <label class="form-label">Kelas</label>
              <input
                :value="selectedStudent?.class || ''"
                class="form-input"
                placeholder="Terisi otomatis"
                readonly
              />
            </div>

            <!-- Violation Type -->
            <div class="form-group">
              <label class="form-label">Jenis Pelanggaran <span class="required">*</span></label>
              <select v-model="violationType" class="form-select">
                <option value="">-- Pilih Jenis Pelanggaran --</option>
                <option v-for="t in violationTypes" :key="t" :value="t">{{ t }}</option>
              </select>
            </div>

            <!-- Severity -->
            <div class="form-group">
              <label class="form-label">Tingkat Keparahan <span class="required">*</span></label>
              <div class="severity-cards">
                <label
                  v-for="level in ['Ringan', 'Sedang', 'Berat']"
                  :key="level"
                  :class="['severity-card', severity === level ? 'active-' + level.toLowerCase() : '']"
                >
                  <input type="radio" v-model="severity" :value="level" class="sr-only" />
                  <div class="severity-icon">
                    <span v-if="level === 'Ringan'">🟢</span>
                    <span v-else-if="level === 'Sedang'">🟡</span>
                    <span v-else>🔴</span>
                  </div>
                  <div class="severity-label">{{ level }}</div>
                  <div class="severity-desc">
                    <template v-if="level === 'Ringan'">1–20 poin</template>
                    <template v-else-if="level === 'Sedang'">21–50 poin</template>
                    <template v-else>51–100 poin</template>
                  </div>
                </label>
              </div>
            </div>

            <!-- Description -->
            <div class="form-group">
              <label class="form-label">Deskripsi Kejadian</label>
              <textarea
                v-model="description"
                class="form-textarea"
                rows="3"
                placeholder="Jelaskan detail kejadian pelanggaran..."
              ></textarea>
            </div>

            <!-- Date -->
            <div class="form-group">
              <label class="form-label">Tanggal Kejadian <span class="required">*</span></label>
              <input v-model="date" type="date" class="form-input" />
            </div>

            <!-- Upload Evidence -->
            <div class="form-group">
              <label class="form-label">Bukti (Opsional)</label>
              <div
                :class="['upload-area', { dragging: isDragging }]"
                @dragover.prevent="isDragging = true"
                @dragleave="isDragging = false"
                @drop.prevent="isDragging = false"
              >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="32" height="32" class="upload-icon">
                  <path d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <p class="upload-text">Seret & lepas file di sini, atau <span class="upload-link">pilih file</span></p>
                <p class="upload-hint">PNG, JPG, PDF hingga 10MB</p>
              </div>
            </div>

            <div class="form-actions">
              <button type="button" class="btn btn-outline" @click="handleCancel">Batal</button>
              <button type="submit" class="btn btn-primary">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
                  <path d="M12 4v16m8-8H4" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                Simpan Pelanggaran
              </button>
            </div>
          </form>
        </div>

        <!-- Recent Submissions -->
        <div class="card recent-section">
          <h3 class="section-title">Input Terakhir</h3>
          <div class="recent-list">
            <div v-for="(item, i) in recentSubmissions" :key="i" class="recent-item">
              <div class="recent-header">
                <span class="recent-student">{{ item.student }}</span>
                <span :class="['badge', getSeverityBadge(item.severity)]">{{ item.severity }}</span>
              </div>
              <div class="recent-class">{{ item.class }}</div>
              <div class="recent-type">{{ item.type }}</div>
              <div class="recent-date">{{ item.date }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-container { display: flex; flex-direction: column; min-height: 100vh; background: var(--bg-base); }
.page-content { padding: 1.5rem 2rem; flex: 1; }
.page-header { margin-bottom: 1.5rem; }

.content-grid { display: grid; grid-template-columns: 1fr 340px; gap: 1.5rem; }

.card { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.5rem; }
.section-title { font-size: 1rem; font-weight: 600; color: var(--text-primary); margin-bottom: 1.25rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-color); }

.required { color: var(--red-500); }

.student-input-wrap { position: relative; }
.student-dropdown { position: absolute; top: calc(100% + 4px); left: 0; right: 0; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 8px; z-index: 100; max-height: 200px; overflow-y: auto; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.student-option { padding: 0.6rem 0.75rem; cursor: pointer; transition: background 0.15s; }
.student-option:hover { background: var(--bg-elevated); }
.option-name { font-weight: 600; font-size: 0.875rem; color: var(--text-primary); }
.option-class { font-size: 0.75rem; color: var(--text-secondary); }

.sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0,0,0,0); }

.severity-cards { display: flex; gap: 0.75rem; }
.severity-card { flex: 1; border: 2px solid var(--border-color); border-radius: 10px; padding: 0.875rem; cursor: pointer; text-align: center; transition: all 0.2s; }
.severity-card:hover { border-color: var(--primary-600); }
.severity-card.active-ringan { border-color: var(--green-500); background: color-mix(in srgb, var(--green-500) 10%, transparent); }
.severity-card.active-sedang { border-color: var(--amber-500); background: color-mix(in srgb, var(--amber-500) 10%, transparent); }
.severity-card.active-berat { border-color: var(--red-500); background: color-mix(in srgb, var(--red-500) 10%, transparent); }
.severity-icon { font-size: 1.5rem; margin-bottom: 4px; }
.severity-label { font-weight: 600; font-size: 0.875rem; color: var(--text-primary); }
.severity-desc { font-size: 0.7rem; color: var(--text-muted); margin-top: 2px; }

.upload-area { border: 2px dashed var(--border-color); border-radius: 10px; padding: 2rem; text-align: center; transition: all 0.2s; cursor: pointer; }
.upload-area.dragging { border-color: var(--primary-600); background: color-mix(in srgb, var(--primary-600) 5%, transparent); }
.upload-icon { color: var(--text-muted); margin: 0 auto 0.75rem; display: block; }
.upload-text { font-size: 0.875rem; color: var(--text-secondary); margin-bottom: 4px; }
.upload-link { color: var(--primary-600); text-decoration: underline; cursor: pointer; }
.upload-hint { font-size: 0.75rem; color: var(--text-muted); }

.form-actions { display: flex; gap: 0.75rem; justify-content: flex-end; padding-top: 1rem; border-top: 1px solid var(--border-color); margin-top: 1rem; }
.btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.875rem; cursor: pointer; border: none; transition: all 0.2s; }
.btn-primary { background: var(--primary-600); color: white; }
.btn-outline { background: transparent; color: var(--text-primary); border: 1.5px solid var(--border-color); }

.recent-list { display: flex; flex-direction: column; gap: 0.75rem; }
.recent-item { padding: 0.875rem; background: var(--bg-base); border: 1px solid var(--border-color); border-radius: 8px; }
.recent-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 4px; }
.recent-student { font-weight: 600; font-size: 0.875rem; color: var(--text-primary); }
.recent-class { font-size: 0.75rem; color: var(--text-secondary); }
.recent-type { font-size: 0.8rem; color: var(--text-secondary); margin-top: 4px; }
.recent-date { font-size: 0.7rem; color: var(--text-muted); margin-top: 4px; }

@media (max-width: 900px) {
  .content-grid { grid-template-columns: 1fr; }
}
</style>
