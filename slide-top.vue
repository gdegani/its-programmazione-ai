<script setup lang="ts">
import { computed } from 'vue'
import { useSlideContext } from '@slidev/client'

const { $page, $frontmatter } = useSlideContext()

// The logo appears only on the deck cover and on the lesson covers
const visible = computed(() => $page.value === 1 || $frontmatter.layout === 'cover')
const logo = `${import.meta.env.BASE_URL}logo-ITS.png`
</script>

<template>
  <img v-if="visible" :src="logo" alt="ITS Meccatronico Veneto" class="absolute top-6 right-8 h-14">
</template>
