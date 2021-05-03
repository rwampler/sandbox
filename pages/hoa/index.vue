<template lang='pug'>
#application
  #render-container

  #lightning-container.lightning(ref='container_lightning')

  #primary-container
    #preface-container(ref='container_preface') rwampler presents
    main-menu(ref='main_menu' :client='client_instance()' :state='state')

</template>

<script lang='coffee'>
import MainMenu from '~/components/hoa/main-menu/main-menu'

import Client from '~/plugins/hoa/client/client.coffee'

LIGHTNING = true

client = if process.browser then new Client() else null
animate = () ->
  client.tick() if client?
  requestAnimationFrame(-> animate())

export default
  layout: 'hoa'
  head:
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/hoa/favicon.ico' },
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css?family=Luckiest+Guy|Oswald&display=swap' }
    ]

  components:
    'main-menu': MainMenu

  data: ->
    state: client?.state_manager?.state

  mounted: ->
    if process.browser
      client?.initialize_with_dom("render-container")
      client?.animation_manager?.initialize_intro(@$refs.container_preface, @$refs.container_lightning)
      client?.animation_manager?.initialize_menu_dom(@$refs.main_menu.$el)
      client?.load_and_initialize()
      animate()

  methods:
    client_instance: -> client

</script>

<style lang='sass' scoped>
@import '~bulma/sass/utilities/_all'
@import '~assets/stylesheets/hoa/variables.sass'

$menu-bg: darken($hoa-color-primary, 8%)
$menu-bg-light: lighten($menu-bg, 3%)
$menu-bg-dark: darken($menu-bg, 5%)

.full-screen
  grid-area: 1 / 1 / 4 / 4
.primary-screen
  grid-area: 2 / 2 / 3 / 3

#application
  display: grid
  grid-template-columns: 20vw auto 20vw
  grid-template-rows: 10vh auto 10vh
  height: 100vh
  position: relative

  @media screen and (max-width: 768px)
    grid-template-columns: 5vw auto 5vw
    grid-template-rows: 5vh auto 5vh

#render-container
  @extend .full-screen
  height: 100vh
  position: relative

#primary-container
  @extend .primary-screen
  position: relative

#preface-container
  color: #EEE
  font-size: 3rem
  left: calc(50% - 15rem)
  position: absolute
  opacity: 0
  text-align: center
  top: calc(40% - 2.5rem)
  width: 30rem
  z-index: 1000

.lightning
  @extend .full-screen
  background-color: $hoa-color-primary
  opacity: 0
  z-index: 100

</style>
