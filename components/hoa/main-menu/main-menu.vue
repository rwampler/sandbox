<template lang='pug'>
  .main-menu
    .main-logo
      logo

    .main-actions
      actions(:client='client' :state='state')

</template>

<script lang='coffee'>
import Logo from '~/components/hoa/main-menu/logo'
import Actions from '~/components/hoa/main-menu/actions'

export default
  props:
    client: Object
    state: Object

  components:
    'logo': Logo
    'actions': Actions

</script>

<style lang='sass' scoped>
@import '~bulma/sass/utilities/_all'
@import '~assets/stylesheets/hoa/variables.sass'

.main-menu
  left: calc(50% - 25rem)
  position: absolute
  opacity: 0
  text-align: center
  top: 0
  width: 50rem
  z-index: 1000

  @media screen and (max-width: 768px)
    left: auto
    width: 100%

.main-actions
  overflow: hidden

</style>
