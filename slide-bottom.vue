<script setup lang="ts">
import { computed } from 'vue'
import { useSlideContext } from '@slidev/client'

const { $nav, $page, $frontmatter } = useSlideContext()

// Title of the lesson the slide belongs to: the closest cover slide before it
const lessonTitle = computed(() => {
  for (let no = $page.value; no >= 1; no--) {
    const slide = $nav.value.slides[no - 1]?.meta?.slide
    if (slide?.frontmatter?.layout === 'cover') return slide.title
  }
  return ''
})

// Hidden on covers, on full-screen images (their citation sits in the same corner)
// and on the slides outside the lessons (title, index, license)
const visible = computed(() =>
  !['cover', 'image'].includes($frontmatter.layout) && !$frontmatter.hideInToc && lessonTitle.value !== '')
</script>

<template>
  <div v-if="visible" class="slide-footer absolute bottom-0 left-0 p-2 text-xs">
    Ing. Giancarlo Degani · {{ lessonTitle }}
  </div>
</template>

<style scoped>
.slide-footer {
  opacity: 0.6;
}
</style>
