<template lang='pug'>
.outer-container
  .menu-loading
    .logo
      .width-fixed

    .progress-bar
      div(:style='loadingWidth')

</template>

<script lang='coffee'>
export default
  props:
    managers: Object
    state: Object

  computed:
    loadingWidth: -> "width: #{if @state.loading then (100 * @state.loadingProgress / @state.loadingTotal).toFixed(0) else 100}%"

</script>

<style lang='sass' scoped>
@import '~bulma/sass/utilities/_all'

.outer-container
  position: relative

.menu-loading
  align-items: center
  background-color: darken(#16161d, 3%)
  border-radius: 1rem
  display: flex
  flex-direction: column
  padding: 2.5rem
  transition: opacity 0.3s
  width: 26rem

  .logo
    animation: spin 3s linear infinite
    display: inline-block
    filter: invert(43%) sepia(41%) saturate(1037%) hue-rotate(172deg) brightness(87%) contrast(84%)
    width: 80%

    .width-fixed
      padding-top: 100%

  .progress-bar
    border: 2px solid #3477bc
    display: inline-block
    height: 4rem
    margin-top: 4rem
    position: relative
    width: 100%

    div
      background-color: #3477bc
      position: absolute
      left: 0
      height: 100%
      top: 0
      width: 0%

</style>
