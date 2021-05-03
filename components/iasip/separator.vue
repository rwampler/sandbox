<template lang='pug'>
.columns.is-mobile
  .column
    .separator-line
  .column.is-narrow.has-text-centered
    .image-container
      img(src='~/assets/images/iasip/logo.png')
  .column
    .separator-line
</template>

<style lang='sass' scoped>

.columns
  margin: 2rem 0

.column
  position: relative
  text-align: center

.separator-line
  background-color: #CCC
  position: absolute
  top: 40%
  left: 0
  width: 100%
  height: 2px

.image-container
  display: inline-block
  padding: 1rem

  img
    height: 2rem
    vertical-align: middle
</style>
