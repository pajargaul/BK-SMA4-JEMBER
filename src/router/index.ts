import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: () => import('../views/landing/LandingPage.vue'), name: 'home' },
    { path: '/login', component: () => import('../views/auth/LoginPage.vue'), name: 'login' },
    { path: '/forgot-password', component: () => import('../views/auth/ForgotPassword.vue'), name: 'forgot-password' },
    { path: '/reset-password', component: () => import('../views/auth/ResetPassword.vue'), name: 'reset-password' },

    // Admin routes
    {
      path: '/admin',
      component: () => import('../views/admin/AdminLayout.vue'),
      meta: { requiresAuth: true, role: 'admin' },
      children: [
        { path: '', redirect: '/admin/dashboard' },
        { path: 'dashboard', component: () => import('../views/admin/AdminDashboard.vue'), name: 'admin-dashboard' },
        { path: 'users', component: () => import('../views/admin/UserManagement.vue'), name: 'admin-users' },
        { path: 'students', component: () => import('../views/admin/StudentData.vue'), name: 'admin-students' },
        { path: 'teachers', component: () => import('../views/admin/TeacherData.vue'), name: 'admin-teachers' },
        { path: 'categories', component: () => import('../views/admin/ViolationCategories.vue'), name: 'admin-categories' },
        { path: 'violation-types', component: () => import('../views/admin/ViolationTypes.vue'), name: 'admin-violation-types' },
        { path: 'fuzzy-variables', component: () => import('../views/admin/FuzzyVariables.vue'), name: 'admin-fuzzy-variables' },
        { path: 'membership-functions', component: () => import('../views/admin/MembershipFunctions.vue'), name: 'admin-membership' },
        { path: 'rule-base', component: () => import('../views/admin/RuleBase.vue'), name: 'admin-rules' },
        { path: 'reports', component: () => import('../views/admin/Reports.vue'), name: 'admin-reports' },
        { path: 'database', component: () => import('../views/admin/DatabasePage.vue'), name: 'admin-database' },
        { path: 'settings', component: () => import('../views/admin/Settings.vue'), name: 'admin-settings' },
        { path: 'profile', component: () => import('../views/admin/ProfilePage.vue'), name: 'admin-profile' },
      ]
    },

    // Guru BK routes
    {
      path: '/guru-bk',
      component: () => import('../views/guru_bk/GuruBKLayout.vue'),
      meta: { requiresAuth: true, role: 'guru_bk' },
      children: [
        { path: '', redirect: '/guru-bk/dashboard' },
        { path: 'dashboard', component: () => import('../views/guru_bk/GuruBKDashboard.vue'), name: 'gurubk-dashboard' },
        { path: 'input-violation', component: () => import('../views/guru_bk/InputViolation.vue'), name: 'gurubk-input' },
        { path: 'monitoring', component: () => import('../views/guru_bk/MonitoringPage.vue'), name: 'gurubk-monitoring' },
        { path: 'violation-history', component: () => import('../views/guru_bk/ViolationHistory.vue'), name: 'gurubk-history' },
        { path: 'fuzzy-evaluation', component: () => import('../views/guru_bk/FuzzyEvaluation.vue'), name: 'gurubk-fuzzy' },
        { path: 'recommendations', component: () => import('../views/guru_bk/Recommendations.vue'), name: 'gurubk-recommendations' },
        { path: 'followup', component: () => import('../views/guru_bk/FollowUp.vue'), name: 'gurubk-followup' },
        { path: 'reports', component: () => import('../views/guru_bk/ReportsPage.vue'), name: 'gurubk-reports' },
        { path: 'profile', component: () => import('../views/guru_bk/ProfilePage.vue'), name: 'gurubk-profile' },
      ]
    },

    // Siswa routes
    {
      path: '/siswa',
      component: () => import('../views/siswa/SiswaLayout.vue'),
      meta: { requiresAuth: true, role: 'siswa' },
      children: [
        { path: '', redirect: '/siswa/dashboard' },
        { path: 'dashboard', component: () => import('../views/siswa/SiswaDashboard.vue'), name: 'siswa-dashboard' },
        { path: 'violations', component: () => import('../views/siswa/ViolationHistory.vue'), name: 'siswa-violations' },
        { path: 'evaluation', component: () => import('../views/siswa/EvaluationStatus.vue'), name: 'siswa-evaluation' },
        { path: 'followup', component: () => import('../views/siswa/FollowUpHistory.vue'), name: 'siswa-followup' },
        { path: 'profile', component: () => import('../views/siswa/ProfilePage.vue'), name: 'siswa-profile' },
      ]
    },

    { path: '/:pathMatch(.*)*', redirect: '/' }
  ]
})

router.beforeEach(async (to) => {
  const auth = useAuthStore()
  if (auth.loading) await new Promise<void>(resolve => { const unwatch = setInterval(() => { if (!auth.loading) { clearInterval(unwatch); resolve() } }, 50) })
  if (to.meta.requiresAuth && !auth.isAuthenticated) return { name: 'login' }
  if (to.meta.role && auth.user?.role !== to.meta.role) {
    if (auth.isAdmin) return { name: 'admin-dashboard' }
    if (auth.isGuruBK) return { name: 'gurubk-dashboard' }
    if (auth.isSiswa) return { name: 'siswa-dashboard' }
    return { name: 'login' }
  }
  if ((to.name === 'login') && auth.isAuthenticated) {
    if (auth.isAdmin) return { name: 'admin-dashboard' }
    if (auth.isGuruBK) return { name: 'gurubk-dashboard' }
    return { name: 'siswa-dashboard' }
  }
})

export default router
