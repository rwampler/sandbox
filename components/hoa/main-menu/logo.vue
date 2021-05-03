<template lang='pug'>
.main-logo
  .main-roof
    .roof-scaler-left
      .roof
    .roof-scaler-right
      .roof

  .main-title
    .row-1.col-1.main-panel-left
    .row-1.col-3.main-panel-right

    .row-2.col-1.main-panel-left
    .row-2.col-2.main-panel-body
      h1.brand-title
        .word
          .letter(v-for="letter of 'HOMEOWNERS'")
            .foreground {{letter}}
            .background {{letter}}
        .word
          .letter(v-for="letter of 'ASSOCIATION'")
            .foreground {{letter}}
            .background {{letter}}
    .row-2.col-3.main-panel-right

    .row-3.col-1.main-panel-left
    .row-3.col-2.main-panel-middle
    .row-3.col-3.main-panel-right

</template>

<script lang='coffee'>
import anime from 'animejs/lib/anime.es.js'

export default
  mounted: ->

    random_swap = (array) -> if anime.random(0, 1) == 0 then array else array.reverse()
    for background in document.getElementsByClassName("background")
      anime({
        targets: background
        direction: 'alternate'
        #easing: 'cubicBezier(.5, .05, .1, .3)'
        easing: 'linear'
        skewX: () -> random_swap([-5, 5])
        rotationX: () -> random_swap([-10, 10])
        scaleX: [1.5, 1.5]
        scaleY: () -> random_swap([1.5, 1.55])
        duration: (el, i) -> anime.random(1000, 1500)
        loop: true
      })

</script>

<style lang='sass' scoped>
@import '~bulma/sass/utilities/_all'
@import '~assets/stylesheets/hoa/variables.sass'
@import '~assets/stylesheets/hoa/hoa-main-menu.sass'

.main-roof
  height: 10rem
  margin-bottom: -2rem
  overflow: hidden
  position: relative

  @media screen and (max-width: 768px)
    height: 10vh

  .roof-scaler-left
    position: absolute
    transform: scale(1, .25) translate(10rem, 1rem)
    transform-origin: left top

    @media screen and (max-width: 768px)
      transform: scale(1, .25) translate(10vh, -1rem)

    .roof
      border-left: 1px solid $menu-bg-light
      transform: rotate(45deg)

  .roof-scaler-right
    position: absolute
    right: 0
    transform: scale(1, .25) translate(-10rem, 1rem)
    transform-origin: right top

    @media screen and (max-width: 768px)
      transform: scale(1, .25) translate(-10vh, -1rem)

    .roof
      border-right: 1px solid $menu-bg-dark
      transform: rotate(-45deg)

  .roof
    background-color: $menu-bg
    height: 40rem
    width: 5rem

    @media screen and (max-width: 768px)
      height: 40vh

.main-title
  display: grid
  grid-template-columns: 2rem auto 2rem
  grid-template-rows: .5rem auto 2rem
  user-select: none

  .main-panel-middle,
  .main-panel-left,
  .main-panel-right
    background-color: $menu-bg

  .main-panel-left
    &.row-1
      @extend .menu-bg-left
    &.row-2
      @extend .menu-bg-left
      @extend .menu-bg-right
    &.row-3
      @extend .menu-bg-left

  .main-panel-right
    &.row-1
      @extend .menu-bg-right
    &.row-2
      @extend .menu-bg-left
      @extend .menu-bg-right
    &.row-3
      @extend .menu-bg-right

  .main-panel-middle
    &.row-3
      @extend .menu-bg-top

  .brand-title
    display: inline-block
    font-size: 6rem
    letter-spacing: .25rem
    line-height: 8rem
    perspective: 60rem
    perspective-origin: center
    margin: 1rem

    @media screen and (max-width: 768px)
      font-size: 3rem
      line-height: 4rem

    .word,
    .letter
      display: inline-block
      position: relative

    .foreground
      color: $hoa-color-primary
      -webkit-text-stroke: 3px #000

    .background
      color: darken($hoa-color-primary, 10%)
      position: absolute
      top: 0
      -webkit-text-stroke: 1px darken($hoa-color-primary, 5%)
      z-index: -100

</style>
