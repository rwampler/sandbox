<template lang='pug'>
#footer-container
  .columns.thanks
    .column.is-6.is-offset-3
      | Fan-made website with no affiliation to
      |
      a(href='https://www.fxnetworks.com/shows/its-always-sunny-in-philadelphia' target='_blank') IASIP
      |  or
      |
      a(href='https://www.fxnetworks.com/' target='_blank') FX Networks

  .columns.is-mobile.links.is-centered
    .column.is-4.is-hidden-touch
    .column
      a(href='https://github.com/rwampler/sandbox-website' target='_blank') GitHub
    .column.is-4.is-hidden-touch

  .columns.copyright
    .column.is-6.is-offset-3
      span(v-once v-html='copyright()')
</template>

<script lang='coffee'>
import moment from 'moment'

export default
  methods:
    copyright: () -> "Copyright &copy; #{moment().year()}"
</script>

<style lang='sass' scoped>
#footer-container
  margin-top: 0rem
  padding: 0 2rem 2rem
  text-align: center

  .links
    font-size: 1.2rem

  a
    color: #FFF
    font-weight: bold
</style>
