<template lang='pug'>
client-only
  nuxt(v-cloak)
</template>

<style lang='sass'>
@import '~assets/stylesheets/hoa/bulma.sass'
@import '~assets/stylesheets/hoa/hoa.sass'
@import '~assets/stylesheets/hoa/variables.sass'

html
  font-size: 12px
  overflow-y: hidden

body
  background-color: #000
  box-sizing: border-box
  color: #EEE
  font-family: 'Oswald', sans-serif
  font-size: 12px
  margin: 0
  overflow: hidden
  padding: 0

h1,
h2
  font-family: 'Luckiest Guy', cursive
</style>
