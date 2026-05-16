<script setup lang="ts">
import { RouterView } from 'vue-router'
import { useThemeStore } from './stores/theme'
const theme = useThemeStore()
</script>

<template>
  <div :class="{ dark: theme.isDark }" style="min-height:100vh">
    <RouterView />
  </div>
</template>
