<template lang='pug'>
client-only
  #application-container(v-cloak)
    header-panel
    separator

    nuxt

    separator
    footer-panel
</template>

<script lang='coffee'>
import FooterPanel from '~/components/iasip/footer-panel.vue'
import HeaderPanel from '~/components/iasip/header-panel.vue'
import Separator from '~/components/iasip/separator.vue'

export default
  components: {
    FooterPanel
    HeaderPanel
    Separator
  }
</script>

<style lang='sass'>
html
  font-size: 12px

body
  background-color: #000
  box-sizing: border-box
  color: #FFF
  font-family: "Courier New", Courier, "Lucida Sans Typewriter", "Lucida Typewriter", monospace
  font-size: 12px

html,
body
  bottom: 0
  background-color: #000
  height: 100%
  left: 0
  margin: 0
  padding: 0
  right: 0
  top: 0

#application-container
  overflow-x: hidden

.echarts
  height: auto!important
  width: auto!important
</style>
