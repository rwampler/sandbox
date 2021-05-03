<template lang='pug'>
.columns
  .column
    .banner.level
      .primary.level-item.is-marginless
        span iasip

</template>

<style lang='sass' scoped>
.banner
  text-align: center

  .primary
    display: inline-block
    font-size: 4rem

    span
      &:not(:first-child)
        margin-left: 1rem

  .secondary
    display: inline-block
    font-family: 'textileregular'
    font-size: 2.25rem

    &.with-margin-left
      margin-left: 2rem

    @media screen and (max-width: 768px)
      margin-bottom: 1rem

    @media screen and (max-width: 1250px) and (min-width: 769px)
      padding-top: .75rem
      text-align: left
</style>
