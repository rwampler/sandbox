<template lang='pug'>
client-only
  #application-container(v-cloak)
    nuxt
</template>

<style lang='sass'>
@import '~assets/stylesheets/pixel-people/bulma.sass'

html
  font-size: 12px

body
  background-color: #ebf1ff
  box-sizing: border-box
  color: #000
  font-family: 'VT323', monospace
  font-size: 12px
  margin: 0
  padding: 0

#application-container
  position: relative
</style>
