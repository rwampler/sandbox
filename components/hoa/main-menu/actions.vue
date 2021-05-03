<template lang='pug'>
.main-actions(ref='container', :class="{'is-loading': is_loading}")
  .row-loading.left
  .row-loading.loading-bar
    .loading-panel
      .progress-bar
        div
  .row-loading.right

  .row-button.a.left
  .row-button.a.button-action.action-a
    a.button.is-fullwidth new game
  .row-button.a.middle
  .row-button.a.button-action.action-b
    a.button.is-fullwidth(disabled='disabled') continue
  .row-button.a.right

  .row-button.b.left
  .row-button.b.button-action.action-a
    a.button.is-fullwidth(href='https://github.com/rwampler/sandbox-website' target='_blank') more info
  .row-button.b.middle
  .row-button.b.button-action.action-b
    a.button.is-fullwidth settings
  .row-button.b.right

  .row-button.c.left
  .row-button.c.right
  .row-button.d.left
  .row-button.d.right

  .row-spacer.a.left
  .row-spacer.a.button-spacer.action-a
  .row-spacer.a.middle
  .row-spacer.a.button-spacer.action-b
  .row-spacer.a.right

  .row-spacer.b.left
  .row-spacer.b.button-spacer.action-a
  .row-spacer.b.middle
  .row-spacer.b.button-spacer.action-b
  .row-spacer.b.right

  .row-spacer.c.left
  .row-spacer.c.button-spacer.action-a
  .row-spacer.c.middle
  .row-spacer.c.button-spacer.action-b
  .row-spacer.c.right

  .row-footer.left
  .row-footer.button-spacer.action-a
  .row-footer.middle
  .row-footer.button-spacer.action-b
  .row-footer.right

</template>

<script lang='coffee'>
export default
  props:
    client: Object
    state: Object

  data: -> {}

  mounted: ->

    @client.animation_manager.initialize_menu_actions_dom(@$refs.container)

  computed:
    is_loading: -> @state.loading

</script>

<style lang='sass' scoped>
@import '~bulma/sass/utilities/_all'
@import '~assets/stylesheets/hoa/variables.sass'
@import '~assets/stylesheets/hoa/hoa-main-menu.sass'

.main-actions
  display: grid
  grid-template-columns: 2rem auto 1rem auto 2rem
  grid-template-rows: 0 auto 1rem 0 0 auto 0 0 2rem

  @media screen and (max-width: 768px)
    grid-template-columns: 2rem auto 0 0 2rem
    grid-template-rows: 0 auto 1rem auto 1rem auto 1rem auto 2rem

  .left,
  .middle,
  .right,
  .button-spacer
    background-color: $menu-bg


  .row-loading
    grid-row: 1 / span 1

    &.left
      @extend .menu-bg-left
      grid-column: 1 / span 1
    &.loading-bar
      grid-column: 2 / span 3
    &.right
      @extend .menu-bg-right
      grid-column: 5 / span 1

  .row-button
    &.a
      grid-row: 2 / span 1
      @media screen and (max-width: 768px)
        &.action-b
          grid-row: 4 / span 1
    &.b
      grid-row: 6 / span 1
      @media screen and (max-width: 768px)
        &.action-b
          grid-row: 8 / span 1
    &.c
      grid-row: 4 / span 1
    &.d
      grid-row: 8 / span 1

    &.left
      @extend .menu-bg-left
      grid-column: 1 / span 1
    &.button-action
      &.action-a
        grid-column: 2 / span 1
      &.action-b
        grid-column: 4 / span 1
        @media screen and (max-width: 768px)
          grid-column: 2 / span 1
    &.middle
      grid-column: 3 / span 1
      @media screen and (max-width: 768px)
        display: none
    &.right
      @extend .menu-bg-right
      grid-column: 5 / span 1

  .row-spacer
    &.a
      grid-row: 3 / span 1
    &.b
      grid-row: 5 / span 1
    &.c
      grid-row: 7 / span 1

    &.left
      @extend .menu-bg-left
      grid-column: 1 / span 1
    &.button-spacer
      border-top: 1px solid $menu-bg-light
      border-bottom: 1px solid $menu-bg-dark
      &.action-a
        grid-column: 2 / span 1
      &.action-b
        grid-column: 4 / span 1
    &.middle
      grid-column: 3 / span 1
    &.right
      @extend .menu-bg-right
      grid-column: 5 / span 1

  .row-footer
    @extend .menu-bg-bottom

    grid-row: 9 / span 1

    &.left
      @extend .menu-bg-left
      grid-column: 1 / span 1
    &.button-action
      &.action-a
        grid-column: 2 / span 1
      &.action-b
        grid-column: 4 / span 1
    &.middle
      grid-column: 3 / span 1
    &.right
      @extend .menu-bg-right
      grid-column: 5 / span 1


  .loading-panel
    height: 8rem
    padding: .5rem
    position: relative

    .progress-bar
      height: 100%
      position: relative
      width: 100%

      > div
        background-color: $hoa-color-primary
        position: absolute
        left: 0
        height: 100%
        top: 0
        width: 0%

  .button
    background: #000
    border-radius: 0
    border: 3px solid #000
    color: $hoa-color-primary
    font-size: 3.25rem
    font-weight: bold
    height: 6rem
    padding-top: calc(.5rem - 1px)

    &[disabled]
      color: #555

    &:not([disabled])
      &:hover
        background: darken($hoa-color-primary, 5%)
        color: #000

      &:active
        background: $hoa-color-primary
        color: #000

.main-actions
  &.is-loading
    grid-template-rows: auto 0 0 0 0 0 0 0 2rem

    .row-button,
    .row-spacer
      display: none

</style>
