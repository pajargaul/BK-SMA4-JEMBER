<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useThemeStore } from '../../stores/theme'

const router = useRouter()
const theme = useThemeStore()
const mobileMenuOpen = ref(false)
const scrolled = ref(false)
const openFaq = ref<number | null>(null)

function scrollToSection(id: string) {
  window.document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
}

const stats = ref([
  { label: 'Total Siswa', value: 0, target: 1247, suffix: '+', icon: '👨‍🎓' },
  { label: 'Pelanggaran Terdata', value: 0, target: 3892, suffix: '+', icon: '📋' },
  { label: 'Monitoring Aktif', value: 0, target: 98, suffix: '%', icon: '📊' },
  { label: 'Tingkat Kedisiplinan', value: 0, target: 87, suffix: '%', icon: '⭐' },
])

const features = [
  { icon: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2', title: 'Monitoring Pelanggaran', desc: 'Pantau dan catat setiap pelanggaran siswa secara real-time dengan sistem terpusat', color: 'primary' },
  { icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z', title: 'Evaluasi Fuzzy Logic', desc: 'Analisis perilaku siswa menggunakan algoritma Fuzzy Logic yang akurat dan terstandar', color: 'teal' },
  { icon: 'M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z', title: 'Dashboard Statistik', desc: 'Visualisasi data pelanggaran dengan grafik interaktif dan laporan komprehensif', color: 'amber' },
  { icon: 'M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z', title: 'Rekomendasi BK', desc: 'Sistem otomatis memberikan rekomendasi tindak lanjut berdasarkan hasil evaluasi', color: 'green' },
  { icon: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z', title: 'Riwayat Pelanggaran', desc: 'Akses lengkap riwayat pelanggaran siswa dengan filter waktu dan kategori', color: 'red' },
  { icon: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z', title: 'Monitoring Perkembangan', desc: 'Tracking perkembangan perilaku siswa dari waktu ke waktu', color: 'primary' },
  { icon: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z', title: 'Laporan Otomatis', desc: 'Generate laporan PDF dan Excel secara otomatis untuk keperluan administrasi', color: 'teal' },
  { icon: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4', title: 'Tracking Tindak Lanjut', desc: 'Pantau progress tindak lanjut konseling dengan timeline yang terstruktur', color: 'amber' },
]

const faqs = [
  { q: 'Apa itu Fuzzy Logic dalam sistem ini?', a: 'Fuzzy Logic adalah metode komputasi yang memungkinkan sistem mengevaluasi tingkat pelanggaran siswa berdasarkan multiple variabel input seperti jumlah, frekuensi, dan tingkat keparahan pelanggaran, menghasilkan output yang lebih akurat dan realistis.' },
  { q: 'Siapa saja yang dapat menggunakan sistem ini?', a: 'Sistem ini dirancang untuk tiga pengguna: Admin (mengelola sistem), Guru BK (input pelanggaran dan evaluasi), dan Siswa (melihat riwayat dan status perilaku mereka).' },
  { q: 'Bagaimana cara sistem memberikan rekomendasi?', a: 'Setelah proses fuzzifikasi, inferensi, dan defuzzifikasi, sistem menghasilkan nilai crisp yang menentukan apakah siswa berada dalam kategori Ringan, Sedang, atau Berat, disertai rekomendasi tindakan BK yang sesuai.' },
  { q: 'Apakah data siswa aman?', a: 'Ya, seluruh data dilindungi dengan enkripsi end-to-end, sistem Row Level Security (RLS) pada database, dan akses berbasis peran yang ketat.' },
  { q: 'Bagaimana cara memulai menggunakan sistem?', a: 'Admin sekolah mendaftarkan akun, kemudian mengatur data siswa, guru BK, kategori pelanggaran, dan parameter fuzzy logic. Setelah itu guru BK dapat langsung mulai mencatat pelanggaran.' },
]

function onScroll() {
  scrolled.value = window.scrollY > 20
}

function animateCounters() {
  stats.value.forEach((stat, i) => {
    const duration = 2000
    const step = stat.target / (duration / 16)
    const timer = setInterval(() => {
      stat.value = Math.min(stat.value + step, stat.target)
      if (stat.value >= stat.target) { stat.value = stat.target; clearInterval(timer) }
    }, 16)
    setTimeout(() => {}, i * 200)
  })
}

onMounted(() => {
  window.addEventListener('scroll', onScroll)
  setTimeout(animateCounters, 500)
})

onUnmounted(() => window.removeEventListener('scroll', onScroll))
</script>

<template>
  <div class="landing">
    <!-- Navbar -->
    <nav :class="['landing-nav', { scrolled }]">
      <div class="nav-container">
        <div class="nav-brand">
          <div class="nav-logo">
            <svg viewBox="0 0 32 32" fill="none" width="32" height="32">
              <rect width="32" height="32" rx="8" fill="#2563EB"/>
              <path d="M8 22L14 10L20 18L23 14L26 22H8Z" fill="white" opacity="0.9"/>
              <circle cx="16" cy="9" r="3" fill="#14B8A6"/>
            </svg>
          </div>
          <div class="nav-brand-text">
            <span class="nav-brand-name">SMAVN4</span>
            <span class="nav-brand-sub">Sistem Monitoring</span>
          </div>
        </div>

        <div :class="['nav-links', { open: mobileMenuOpen }]">
          <a href="#beranda" class="nav-item" @click="mobileMenuOpen=false">Beranda</a>
          <a href="#fitur" class="nav-item" @click="mobileMenuOpen=false">Fitur</a>
          <a href="#tentang" class="nav-item" @click="mobileMenuOpen=false">Tentang</a>
          <a href="#manfaat" class="nav-item" @click="mobileMenuOpen=false">Manfaat</a>
          <a href="#faq" class="nav-item" @click="mobileMenuOpen=false">FAQ</a>
        </div>

        <div class="nav-actions">
          <button class="btn-theme-toggle" @click="theme.toggle()" :title="theme.isDark ? 'Light mode' : 'Dark mode'">
            <svg v-if="theme.isDark" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
            <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"/></svg>
          </button>
          <button class="btn btn-outline btn-sm" @click="router.push('/login')">Login</button>
          <button class="btn btn-primary btn-sm" @click="router.push('/login')">Mulai Sekarang</button>
        </div>

        <button class="mobile-menu-btn" @click="mobileMenuOpen=!mobileMenuOpen">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="22" height="22">
            <path v-if="!mobileMenuOpen" d="M3 12h18M3 6h18M3 18h18"/>
            <path v-else d="M18 6L6 18M6 6l12 12"/>
          </svg>
        </button>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero" id="beranda">
      <div class="hero-bg-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
      </div>
      <div class="container">
        <div class="hero-content">
          <div class="hero-text">
            <div class="hero-badge">
              <span class="badge-dot"></span>
              SMA Negeri 4 Jember
            </div>
            <h1 class="hero-title">
              Sistem Monitoring<br>
              <span class="hero-title-accent">Pelanggaran Siswa</span><br>
              Berbasis Fuzzy Logic
            </h1>
            <p class="hero-subtitle">
              Sistem cerdas untuk membantu guru BK melakukan monitoring, evaluasi, dan tindak lanjut pelanggaran siswa secara efektif menggunakan teknologi Fuzzy Logic
            </p>
            <div class="hero-actions">
              <button class="btn btn-primary btn-lg" @click="router.push('/login')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                Mulai Sekarang
              </button>
              <button class="btn btn-outline btn-lg" @click="scrollToSection('tentang')">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                Pelajari Sistem
              </button>
            </div>
            <div class="hero-stats">
              <div class="hero-stat"><span class="hero-stat-num">1200+</span><span class="hero-stat-label">Siswa</span></div>
              <div class="hero-stat-div"></div>
              <div class="hero-stat"><span class="hero-stat-num">98%</span><span class="hero-stat-label">Akurasi</span></div>
              <div class="hero-stat-div"></div>
              <div class="hero-stat"><span class="hero-stat-num">3</span><span class="hero-stat-label">Modul Utama</span></div>
            </div>
          </div>
          <div class="hero-visual">
            <div class="dashboard-mockup">
              <div class="mockup-topbar">
                <div class="mockup-dots">
                  <span></span><span></span><span></span>
                </div>
                <div class="mockup-title">Dashboard Guru BK</div>
              </div>
              <div class="mockup-content">
                <div class="mockup-cards">
                  <div class="mockup-card red">
                    <div class="mockup-card-num">24</div>
                    <div class="mockup-card-label">Pelanggaran Hari Ini</div>
                  </div>
                  <div class="mockup-card amber">
                    <div class="mockup-card-num">8</div>
                    <div class="mockup-card-label">Prioritas BK</div>
                  </div>
                  <div class="mockup-card green">
                    <div class="mockup-card-num">87%</div>
                    <div class="mockup-card-label">Kedisiplinan</div>
                  </div>
                </div>
                <div class="mockup-chart">
                  <div class="chart-bars">
                    <div v-for="h in [40,65,50,80,55,70,90]" :key="h" class="chart-bar" :style="{height: h+'%'}"></div>
                  </div>
                  <div class="chart-label">Tren Pelanggaran Mingguan</div>
                </div>
                <div class="mockup-table">
                  <div v-for="s in ['Andi S. - Kelas XI IPA 2','Budi P. - Kelas X IPS 1','Citra A. - Kelas XII IPA 1']" :key="s" class="mockup-row">
                    <div class="mockup-avatar"></div>
                    <div class="mockup-info">
                      <div class="mockup-name">{{ s }}</div>
                      <div class="mockup-badge"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats-section" id="statistik">
      <div class="container">
        <div class="stats-row">
          <div v-for="stat in stats" :key="stat.label" class="stat-item">
            <div class="stat-icon">{{ stat.icon }}</div>
            <div class="stat-num">{{ Math.floor(stat.value) }}{{ stat.suffix }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="fitur">
      <div class="container">
        <div class="section-header">
          <div class="section-tag">Fitur Unggulan</div>
          <h2 class="section-title">Semua yang Anda Butuhkan</h2>
          <p class="section-subtitle">Sistem lengkap untuk monitoring dan evaluasi pelanggaran siswa berbasis teknologi</p>
        </div>
        <div class="features-grid">
          <div v-for="f in features" :key="f.title" :class="['feature-card', f.color]">
            <div :class="['feature-icon', f.color]">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="24" height="24">
                <path :d="f.icon"/>
              </svg>
            </div>
            <h3 class="feature-title">{{ f.title }}</h3>
            <p class="feature-desc">{{ f.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works -->
    <section class="how-section" id="tentang">
      <div class="container">
        <div class="section-header">
          <div class="section-tag">Alur Sistem</div>
          <h2 class="section-title">Cara Kerja Sistem</h2>
          <p class="section-subtitle">Proses evaluasi menggunakan metode Fuzzy Logic Mamdani</p>
        </div>
        <div class="flow-diagram">
          <div v-for="(step, i) in [
            { num: '01', title: 'Input Pelanggaran', desc: 'Guru BK mencatat data pelanggaran siswa', icon: '📝', color: 'primary' },
            { num: '02', title: 'Fuzzifikasi', desc: 'Nilai crisp dikonversi ke nilai fuzzy', icon: '🔄', color: 'teal' },
            { num: '03', title: 'Rule Inference', desc: 'Aturan IF-THEN diterapkan pada nilai fuzzy', icon: '⚙️', color: 'amber' },
            { num: '04', title: 'Defuzzifikasi', desc: 'Nilai fuzzy dikonversi kembali ke crisp value', icon: '📊', color: 'green' },
            { num: '05', title: 'Hasil Evaluasi', desc: 'Kategori Ringan / Sedang / Berat ditentukan', icon: '✅', color: 'primary' },
            { num: '06', title: 'Rekomendasi', desc: 'Sistem memberikan saran tindak lanjut BK', icon: '💡', color: 'teal' },
          ]" :key="i" class="flow-item-wrapper">
            <div :class="['flow-item', step.color]">
              <div class="flow-num">{{ step.num }}</div>
              <div class="flow-icon">{{ step.icon }}</div>
              <h4 class="flow-title">{{ step.title }}</h4>
              <p class="flow-desc">{{ step.desc }}</p>
            </div>
            <div v-if="i < 5" class="flow-arrow">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="20" height="20"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Benefits Section -->
    <section class="benefits-section" id="manfaat">
      <div class="container">
        <div class="section-header">
          <div class="section-tag">Manfaat</div>
          <h2 class="section-title">Manfaat untuk Semua Pihak</h2>
          <p class="section-subtitle">Solusi komprehensif yang menguntungkan seluruh ekosistem sekolah</p>
        </div>
        <div class="benefits-grid">
          <div class="benefit-card school">
            <div class="benefit-header">
              <div class="benefit-icon">🏫</div>
              <h3>Sekolah</h3>
            </div>
            <ul class="benefit-list">
              <li>Data pelanggaran terpusat dan terstruktur</li>
              <li>Laporan administrasi otomatis</li>
              <li>Monitoring tingkat kedisiplinan sekolah</li>
              <li>Dashboard statistik komprehensif</li>
              <li>Pengambilan keputusan berbasis data</li>
            </ul>
          </div>
          <div class="benefit-card teacher">
            <div class="benefit-header">
              <div class="benefit-icon">👨‍🏫</div>
              <h3>Guru BK</h3>
            </div>
            <ul class="benefit-list">
              <li>Input pelanggaran yang mudah dan cepat</li>
              <li>Evaluasi otomatis dengan Fuzzy Logic</li>
              <li>Rekomendasi tindakan yang terstandar</li>
              <li>Tracking progress konseling siswa</li>
              <li>Notifikasi siswa prioritas</li>
            </ul>
          </div>
          <div class="benefit-card student">
            <div class="benefit-header">
              <div class="benefit-icon">👨‍🎓</div>
              <h3>Siswa</h3>
            </div>
            <ul class="benefit-list">
              <li>Akses riwayat pelanggaran pribadi</li>
              <li>Transparansi status perilaku</li>
              <li>Notifikasi konseling terjadwal</li>
              <li>Motivasi untuk memperbaiki perilaku</li>
              <li>Progress perkembangan yang terukur</li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <!-- FAQ Section -->
    <section class="faq-section" id="faq">
      <div class="container">
        <div class="section-header">
          <div class="section-tag">FAQ</div>
          <h2 class="section-title">Pertanyaan Umum</h2>
          <p class="section-subtitle">Jawaban atas pertanyaan yang sering ditanyakan</p>
        </div>
        <div class="faq-list">
          <div v-for="(faq, i) in faqs" :key="i" class="faq-item">
            <button class="faq-question" @click="openFaq = openFaq === i ? null : i">
              <span>{{ faq.q }}</span>
              <svg :class="['faq-arrow', { open: openFaq === i }]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18"><path d="M6 9l6 6 6-6"/></svg>
            </button>
            <div v-if="openFaq === i" class="faq-answer">{{ faq.a }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
      <div class="container">
        <div class="cta-card">
          <h2>Mulai Gunakan Sistem Sekarang</h2>
          <p>Tingkatkan efektivitas monitoring pelanggaran siswa di SMA Negeri 4 Jember</p>
          <button class="btn btn-primary btn-lg" @click="router.push('/login')">Login ke Sistem</button>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
      <div class="container">
        <div class="footer-grid">
          <div class="footer-brand">
            <div class="footer-logo">
              <svg viewBox="0 0 32 32" fill="none" width="32" height="32">
                <rect width="32" height="32" rx="8" fill="#2563EB"/>
                <path d="M8 22L14 10L20 18L23 14L26 22H8Z" fill="white" opacity="0.9"/>
                <circle cx="16" cy="9" r="3" fill="#14B8A6"/>
              </svg>
              <span>SMAVN4 Monitoring</span>
            </div>
            <p class="footer-desc">Sistem Monitoring Pelanggaran Siswa Berbasis Fuzzy Logic untuk SMA Negeri 4 Jember</p>
          </div>
          <div class="footer-col">
            <h4>Sistem</h4>
            <a href="#fitur">Fitur</a>
            <a href="#tentang">Cara Kerja</a>
            <a href="#manfaat">Manfaat</a>
          </div>
          <div class="footer-col">
            <h4>Akses</h4>
            <a @click="router.push('/login')">Login Admin</a>
            <a @click="router.push('/login')">Login Guru BK</a>
            <a @click="router.push('/login')">Login Siswa</a>
          </div>
          <div class="footer-col">
            <h4>Kontak</h4>
            <span>SMA Negeri 4 Jember</span>
            <span>Jember, Jawa Timur</span>
            <span>info@sman4jember.sch.id</span>
          </div>
        </div>
        <div class="footer-bottom">
          <span>© 2024 SMA Negeri 4 Jember. Sistem Monitoring Berbasis Fuzzy Logic.</span>
          <div class="footer-links">
            <a href="#">Kebijakan Privasi</a>
            <a href="#">Syarat Penggunaan</a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.landing { background: var(--bg-base); color: var(--text-primary); }
.container { max-width: 1200px; margin: 0 auto; padding: 0 24px; }

/* Navbar */
.landing-nav {
  position: fixed; top: 0; left: 0; right: 0; z-index: 100;
  padding: 16px 0; transition: all 0.3s ease;
}
.landing-nav.scrolled {
  background: var(--bg-overlay);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-bottom: 1px solid var(--border-color);
  padding: 10px 0;
  box-shadow: 0 2px 20px rgba(0,0,0,0.07);
}
.nav-container { max-width: 1200px; margin: 0 auto; padding: 0 24px; display: flex; align-items: center; gap: 32px; }
.nav-brand { display: flex; align-items: center; gap: 10px; }
.nav-brand-text { display: flex; flex-direction: column; line-height: 1.1; }
.nav-brand-name { font-size: 15px; font-weight: 700; color: var(--primary-600); }
.nav-brand-sub { font-size: 10px; color: var(--text-muted); font-weight: 500; }
.nav-links { display: flex; align-items: center; gap: 4px; margin-left: auto; }
.nav-item { padding: 8px 14px; border-radius: 8px; font-size: 14px; font-weight: 500; color: var(--text-secondary); transition: all 0.2s; cursor: pointer; }
.nav-item:hover { color: var(--primary-600); background: var(--primary-50); }
.dark .nav-item:hover { background: rgba(37,99,235,0.1); }
.nav-actions { display: flex; align-items: center; gap: 8px; }
.btn-theme-toggle { width: 36px; height: 36px; border-radius: 8px; border: 1.5px solid var(--border-color); background: var(--bg-surface); color: var(--text-secondary); display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; }
.btn-theme-toggle:hover { border-color: var(--primary-400); color: var(--primary-600); }
.mobile-menu-btn { display: none; background: none; border: none; cursor: pointer; color: var(--text-primary); padding: 4px; }

/* Hero */
.hero { padding: 130px 0 80px; position: relative; overflow: hidden; }
.hero-bg-shapes { position: absolute; inset: 0; pointer-events: none; overflow: hidden; }
.shape { position: absolute; border-radius: 50%; filter: blur(80px); opacity: 0.12; }
.shape-1 { width: 600px; height: 600px; background: var(--primary-500); top: -200px; right: -200px; }
.shape-2 { width: 400px; height: 400px; background: var(--teal-500); bottom: -100px; left: -100px; }
.shape-3 { width: 300px; height: 300px; background: var(--amber-400); top: 200px; left: 40%; }
.hero-content { display: grid; grid-template-columns: 1fr 1fr; gap: 64px; align-items: center; }
.hero-badge { display: inline-flex; align-items: center; gap: 8px; background: var(--primary-50); border: 1px solid var(--primary-200); color: var(--primary-700); font-size: 12px; font-weight: 600; padding: 6px 14px; border-radius: 100px; margin-bottom: 24px; }
.dark .hero-badge { background: rgba(37,99,235,0.15); border-color: rgba(37,99,235,0.3); color: var(--primary-300); }
.badge-dot { width: 6px; height: 6px; background: var(--primary-500); border-radius: 50%; animation: pulse 2s infinite; }
.hero-title { font-size: 3rem; font-weight: 800; line-height: 1.15; margin-bottom: 20px; color: var(--text-primary); }
.hero-title-accent { background: linear-gradient(135deg, #2563EB, #14B8A6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.hero-subtitle { font-size: 16px; line-height: 1.7; color: var(--text-secondary); margin-bottom: 32px; max-width: 480px; }
.hero-actions { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 40px; }
.hero-stats { display: flex; align-items: center; gap: 20px; }
.hero-stat { text-align: center; }
.hero-stat-num { display: block; font-size: 22px; font-weight: 800; color: var(--primary-600); }
.hero-stat-label { font-size: 12px; color: var(--text-muted); }
.hero-stat-div { width: 1px; height: 32px; background: var(--border-color); }

/* Dashboard mockup */
.hero-visual { display: flex; justify-content: center; }
.dashboard-mockup {
  background: var(--bg-surface);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 25px 50px rgba(0,0,0,0.12);
  width: 100%;
  max-width: 480px;
  animation: fadeIn 0.8s ease 0.3s both;
}
.mockup-topbar { background: var(--gray-50); padding: 12px 16px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
.dark .mockup-topbar { background: var(--bg-elevated); }
.mockup-dots { display: flex; gap: 6px; }
.mockup-dots span { width: 10px; height: 10px; border-radius: 50%; background: var(--gray-300); }
.mockup-dots span:first-child { background: #EF4444; }
.mockup-dots span:nth-child(2) { background: #F59E0B; }
.mockup-dots span:last-child { background: #22C55E; }
.mockup-title { font-size: 12px; font-weight: 600; color: var(--text-muted); }
.mockup-content { padding: 16px; display: flex; flex-direction: column; gap: 12px; }
.mockup-cards { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 8px; }
.mockup-card { border-radius: 10px; padding: 10px; text-align: center; }
.mockup-card.red { background: #FEF2F2; }
.mockup-card.amber { background: #FFFBEB; }
.mockup-card.green { background: #F0FDF4; }
.dark .mockup-card.red { background: rgba(239,68,68,0.1); }
.dark .mockup-card.amber { background: rgba(245,158,11,0.1); }
.dark .mockup-card.green { background: rgba(34,197,94,0.1); }
.mockup-card-num { font-size: 18px; font-weight: 800; color: var(--text-primary); }
.mockup-card-label { font-size: 9px; color: var(--text-muted); margin-top: 2px; }
.mockup-chart { background: var(--gray-50); border-radius: 10px; padding: 12px; }
.dark .mockup-chart { background: var(--bg-elevated); }
.chart-bars { display: flex; align-items: flex-end; gap: 6px; height: 60px; margin-bottom: 8px; }
.chart-bar { flex: 1; background: linear-gradient(180deg, #2563EB, #60A5FA); border-radius: 4px 4px 0 0; transition: height 0.5s ease; }
.chart-label { font-size: 10px; color: var(--text-muted); text-align: center; }
.mockup-table { display: flex; flex-direction: column; gap: 6px; }
.mockup-row { display: flex; align-items: center; gap: 10px; padding: 8px; border-radius: 8px; background: var(--gray-50); }
.dark .mockup-row { background: var(--bg-elevated); }
.mockup-avatar { width: 28px; height: 28px; border-radius: 50%; background: linear-gradient(135deg, #2563EB, #14B8A6); flex-shrink: 0; }
.mockup-info { flex: 1; }
.mockup-name { font-size: 11px; font-weight: 600; color: var(--text-primary); }
.mockup-badge { width: 50px; height: 6px; border-radius: 3px; background: var(--amber-300); margin-top: 4px; }

/* Stats section */
.stats-section { padding: 48px 0; background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 100%); }
.stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 32px; }
.stat-item { text-align: center; color: white; }
.stat-icon { font-size: 28px; margin-bottom: 8px; }
.stat-num { font-size: 32px; font-weight: 800; line-height: 1; margin-bottom: 6px; }
.stat-label { font-size: 13px; opacity: 0.85; font-weight: 500; }

/* Section headers */
.section-header { text-align: center; margin-bottom: 56px; }
.section-tag { display: inline-block; background: var(--primary-50); color: var(--primary-600); font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; padding: 6px 16px; border-radius: 100px; margin-bottom: 16px; border: 1px solid var(--primary-200); }
.dark .section-tag { background: rgba(37,99,235,0.15); border-color: rgba(37,99,235,0.3); color: var(--primary-400); }
.section-title { font-size: 2.25rem; font-weight: 800; margin-bottom: 16px; }
.section-subtitle { font-size: 16px; color: var(--text-secondary); max-width: 600px; margin: 0 auto; }

/* Features */
.features-section { padding: 96px 0; }
.features-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
.feature-card {
  background: var(--bg-surface);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  padding: 24px;
  transition: all 0.3s ease;
  cursor: default;
}
.feature-card:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(0,0,0,0.08); }
.feature-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 16px; }
.feature-icon.primary { background: var(--primary-50); color: var(--primary-600); }
.feature-icon.teal { background: var(--teal-50); color: var(--teal-600); }
.feature-icon.amber { background: var(--amber-50); color: var(--amber-600); }
.feature-icon.green { background: var(--green-50); color: var(--green-600); }
.feature-icon.red { background: var(--red-50); color: var(--red-600); }
.dark .feature-icon.primary { background: rgba(37,99,235,0.15); color: var(--primary-400); }
.dark .feature-icon.teal { background: rgba(20,184,166,0.15); color: var(--teal-400); }
.dark .feature-icon.amber { background: rgba(245,158,11,0.15); color: var(--amber-400); }
.dark .feature-icon.green { background: rgba(34,197,94,0.15); color: var(--green-400); }
.dark .feature-icon.red { background: rgba(239,68,68,0.15); color: var(--red-400); }
.feature-title { font-size: 15px; font-weight: 700; margin-bottom: 8px; color: var(--text-primary); }
.feature-desc { font-size: 13px; color: var(--text-secondary); line-height: 1.6; }

/* How it works */
.how-section { padding: 96px 0; background: var(--gray-50); }
.dark .how-section { background: var(--bg-elevated); }
.flow-diagram { display: flex; align-items: flex-start; justify-content: center; flex-wrap: wrap; gap: 0; }
.flow-item-wrapper { display: flex; align-items: center; }
.flow-item { width: 160px; background: var(--bg-surface); border-radius: 16px; padding: 20px 16px; text-align: center; border: 1px solid var(--border-color); box-shadow: var(--shadow-sm); transition: all 0.3s; }
.flow-item:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); }
.flow-num { font-size: 11px; font-weight: 800; color: var(--text-muted); letter-spacing: 0.1em; margin-bottom: 8px; }
.flow-icon { font-size: 28px; margin-bottom: 8px; }
.flow-title { font-size: 13px; font-weight: 700; margin-bottom: 6px; color: var(--text-primary); }
.flow-desc { font-size: 11px; color: var(--text-muted); line-height: 1.5; }
.flow-arrow { padding: 0 8px; color: var(--text-muted); }

/* Benefits */
.benefits-section { padding: 96px 0; }
.benefits-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
.benefit-card { background: var(--bg-surface); border-radius: 20px; padding: 32px; border: 1px solid var(--border-color); position: relative; overflow: hidden; }
.benefit-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; }
.benefit-card.school::before { background: linear-gradient(90deg, var(--primary-500), var(--primary-400)); }
.benefit-card.teacher::before { background: linear-gradient(90deg, var(--teal-500), var(--teal-400)); }
.benefit-card.student::before { background: linear-gradient(90deg, var(--amber-500), var(--amber-400)); }
.benefit-header { display: flex; align-items: center; gap: 12px; margin-bottom: 20px; }
.benefit-icon { font-size: 32px; }
.benefit-header h3 { font-size: 18px; font-weight: 700; }
.benefit-list { list-style: none; display: flex; flex-direction: column; gap: 12px; }
.benefit-list li { font-size: 14px; color: var(--text-secondary); padding-left: 20px; position: relative; line-height: 1.5; }
.benefit-list li::before { content: '✓'; position: absolute; left: 0; color: var(--green-500); font-weight: 700; }

/* FAQ */
.faq-section { padding: 96px 0; background: var(--gray-50); }
.dark .faq-section { background: var(--bg-elevated); }
.faq-list { max-width: 720px; margin: 0 auto; display: flex; flex-direction: column; gap: 12px; }
.faq-item { background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; }
.faq-question { width: 100%; display: flex; align-items: center; justify-content: space-between; padding: 18px 20px; background: none; border: none; cursor: pointer; font-family: var(--font-primary); font-size: 15px; font-weight: 600; color: var(--text-primary); text-align: left; }
.faq-question:hover { background: var(--gray-50); }
.dark .faq-question:hover { background: var(--bg-elevated); }
.faq-arrow { transition: transform 0.3s; flex-shrink: 0; color: var(--text-muted); }
.faq-arrow.open { transform: rotate(180deg); color: var(--primary-600); }
.faq-answer { padding: 0 20px 18px; font-size: 14px; color: var(--text-secondary); line-height: 1.7; }

/* CTA */
.cta-section { padding: 96px 0; }
.cta-card { background: linear-gradient(135deg, #2563EB 0%, #1D4ED8 60%, #0D9488 100%); border-radius: 24px; padding: 64px 48px; text-align: center; color: white; }
.cta-card h2 { font-size: 2.25rem; font-weight: 800; margin-bottom: 16px; }
.cta-card p { font-size: 16px; opacity: 0.85; margin-bottom: 32px; }
.cta-card .btn-primary { background: white; color: var(--primary-700); }
.cta-card .btn-primary:hover { background: var(--primary-50); transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.2); }

/* Footer */
.footer { background: var(--gray-900); color: #94A3B8; padding: 64px 0 32px; }
.dark .footer { background: #020617; }
.footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; margin-bottom: 48px; }
.footer-logo { display: flex; align-items: center; gap: 10px; font-size: 16px; font-weight: 700; color: white; margin-bottom: 16px; }
.footer-desc { font-size: 13px; line-height: 1.7; }
.footer-col { display: flex; flex-direction: column; gap: 12px; }
.footer-col h4 { font-size: 13px; font-weight: 700; color: white; text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 4px; }
.footer-col a, .footer-col span { font-size: 13px; color: #94A3B8; cursor: pointer; transition: color 0.2s; display: block; }
.footer-col a:hover { color: white; }
.footer-bottom { border-top: 1px solid #1E293B; padding-top: 24px; display: flex; align-items: center; justify-content: space-between; }
.footer-bottom span { font-size: 12px; }
.footer-links { display: flex; gap: 20px; }
.footer-links a { font-size: 12px; color: #64748B; cursor: pointer; transition: color 0.2s; }
.footer-links a:hover { color: white; }

@media (max-width: 1024px) {
  .features-grid { grid-template-columns: repeat(2, 1fr); }
  .hero-content { grid-template-columns: 1fr; gap: 48px; }
  .hero-visual { display: none; }
  .stats-row { grid-template-columns: repeat(2, 1fr); gap: 24px; }
}
@media (max-width: 768px) {
  .nav-links { display: none; }
  .nav-links.open { display: flex; flex-direction: column; position: absolute; top: 100%; left: 0; right: 0; background: var(--bg-surface); padding: 16px; border-bottom: 1px solid var(--border-color); }
  .mobile-menu-btn { display: flex; }
  .benefits-grid { grid-template-columns: 1fr; }
  .footer-grid { grid-template-columns: 1fr 1fr; gap: 32px; }
  .flow-diagram { flex-direction: column; align-items: center; }
  .flow-arrow { transform: rotate(90deg); padding: 4px 0; }
}
@media (max-width: 480px) {
  .features-grid { grid-template-columns: 1fr; }
  .hero-title { font-size: 2rem; }
  .footer-grid { grid-template-columns: 1fr; }
  .stats-row { grid-template-columns: repeat(2, 1fr); }
}
</style>
