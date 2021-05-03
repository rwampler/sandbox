<template lang='pug'>
.profession
  .icon
    .image.category(:style='categoryColor')
    .count x{{profession.count}}
    a.button.is-small.count-action.decrease(@click.stop.prevent="$emit('decrease')") -
    a.button.is-small.count-action.increase(@click.stop.prevent="$emit('increase')") +

  .name {{profession.name}}

</template>

<script lang='coffee'>
import _ from 'lodash'

DEFAULT_COLOR = [0, 255, 255] #00FFFF
CATEGORY_COLORS = {
  Academic: [163, 38, 164] #a326a4
  Administration: [123, 152, 19] #7b9813
  Business: [109, 109, 20] #6d6d14
  Creative: [166, 126, 10] #a67e0a
  Curious: [0, 255, 255] #00FFFF
  Enchanted: [0, 255, 255] #00FFFF
  Evil: [40, 8, 119] #280877
  Explorers: [145, 155, 8] #919b08
  Hospitality: [6, 149, 109] #06956d
  Law: [71, 70, 157] #47469d
  Maintenance: [47, 118, 44] #2f762c
  Media: [151, 50, 52] #973234
  Medical: [103, 68, 155] #67449b
  Music: [147, 75, 45] #934b2d
  Performers: [41, 162, 121] #29a279
  Production: [119, 108, 21] #776c15
  Research: [161, 118, 103] #a17667
  Resident: [45, 119, 44] #2d772c
  Services: [45, 119, 42] #2d772a
  Sports: [77, 37, 98] #4d2562
  Technical: [86, 21, 43] #56152b
  Transport: [39, 76, 27] #274c1b
}

export default
  props:
    profession: Object

  computed:
    categoryColor: ->
      rgb = _.clone(CATEGORY_COLORS[@profession.category] || DEFAULT_COLOR)
      rgb.push(if @profession.count > 0 then .9 else .1)
      "background-color: rgba(#{rgb.join(', ')})"


</script>

<style lang='sass' scoped>
@import '~bulma/sass/utilities/_all'

.profession
  align-items: center
  display: inline-flex
  flex-direction: column

  .icon
    height: 7rem
    position: relative
    width: 10rem

    .image
      border: 1px solid
      height: 6rem
      width: 6rem

    .count
      font-size: 3rem
      position: absolute

    .count-action
      position: absolute
      bottom: 0

      &.decrease
        left: 1rem

      &.increase
        right: 1rem

  .name
    align-items: center
    display: inline-flex
    font-size: 1.4rem
    height: 3rem
    justify-content: center
    line-height: 1.25rem
    padding: .25rem .5rem
    text-align: center
    text-transform: uppercase
    width: 10rem

</style>
