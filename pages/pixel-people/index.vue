<template lang='pug'>
#container-main
  h3 Statistics
  .content.statistics
    div {{professionTotalCount}} total people
    div {{Object.keys(professionCounts).length}} / {{Object.keys(professionsByName).length}}

  h3 Gallery
  .gallery
    .page(v-for='group,groupIndex in professionGroups')
      .page-label Page {{groupIndex + 1}}
      .professions
        .row(v-for='rowIndex in 5')
          template(v-for='columnIndex in 4')
            template(v-if='group.length > rowIndex - 1 && group[rowIndex - 1].length > columnIndex - 1')
              profession(:profession='group[rowIndex - 1][columnIndex - 1]' @decrease='decreaseProfression(group[rowIndex - 1][columnIndex - 1])' @increase='increaseProfression(group[rowIndex - 1][columnIndex - 1])')
            template(v-else)
              .profession-placeholder

  h3 Special Genes
  ul.special-genes
    li(v-for='gene in specialGenes')
      label.checkbox
        input(type='checkbox' v-model='gene.acquired')
        | {{gene.name}}

  h3 Pending
  ul.pending-professions
    li(v-for='pendingName,index in professionsPending') {{index + 1}}) {{pendingName}} = {{professionsByName[pendingName].parentA}} + {{professionsByName[pendingName].parentB}}, {{professionPendingBuildingCount(pendingName)}} new buildings

  h3 Buildings
  .columns.buildings
    .column.content
      h4 Completed
      ol
        li(v-for='buildingName,index in completedBuildings') {{buildingName}}

    .column.content
      h4 Pending
      ol
        li(v-for='buildingName,index in pendingBuildings') {{buildingName}}

</template>

<script lang='coffee'>
import _ from 'lodash'

import Profession from '~/components/pixel-people/profession'


export default
  layout: 'pixel-people'
  head:
    link: [
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=VT323&display=swap' }
    ]

  components: {
    Profession
  }

  data: ->
    professions: _.map(process.env.PROFESSIONS, (p) -> _.assignIn(_.clone(p), { count: 0 }))
    specialGenes: _.map(process.env.SPECIAL_GENES, (p) -> _.assignIn(_.clone(p), { acquired: false }))

  computed:
    professionsByName: -> _.fromPairs(_.map(@professions, (p) -> [p.name, p]))
    professionGroups: -> _.map(_.chunk(@professions, 20), (g) -> _.chunk(g, 4))
    professionCounts: -> _.fromPairs(_.filter(_.map(@professions, (p) -> [p.name, p.count]), (p) -> p[1] > 0))
    professionTotalCount: -> _.reduce(_.values(@professionCounts), ((sum, n) -> sum + n), 0)

    specialGenesByName: -> _.fromPairs(_.map(@specialGenes, (p) -> [p.name, p]))
    specialGenesAcquired: -> _.fromPairs(_.filter(_.map(@specialGenes, (p) -> [p.name, p.acquired]), (p) -> p[1]))

    professionsPending: ->
      pending = []
      for profession in @professions
        continue if profession.placeholder || profession.count
        continue unless profession.parentA? && profession.parentB?

        hasParentA = @specialGenesByName[profession.parentA]?.acquired || @professionCounts[profession.parentA] > 0
        hasParentB = @specialGenesByName[profession.parentB]?.acquired || @professionCounts[profession.parentB] > 0
        pending.push profession.name if hasParentA && hasParentB
      pending

    completedBuildings: -> _.uniq(_.flatten(_.map(Object.keys(@professionCounts), (p) => @professionsByName[p].buildings)))
    pendingBuildings: -> _.differenceWith(_.uniq(_.flatten(_.map(@professionsPending, (p) => @professionsByName[p].buildings))), @completedBuildings)

  mounted: ->
    @loadProfessionCounts()
    @loadSpecialGenes()

  watch:
    specialGenesAcquired: -> @saveSpecialGenes()

  methods:
    decreaseProfression: (profression) ->
      profression.count -= 1 if profression.count > 0
      profression.count = 0 if !profression.count || profression.count < 0
      @saveProfessionCounts()

    increaseProfression: (profression) ->
      profression.count = 0 if !profression.count || profression.count < 0
      profression.count += 1
      @saveProfessionCounts()

    professionPendingBuildingCount: (name) -> _.differenceWith(@professionsByName[name].buildings, @completedBuildings).length

    loadProfessionCounts: () ->
      rawCounts = localStorage.getItem('professionCounts')
      keyCounts = if rawCounts? then JSON.parse(rawCounts) else {}
      for profession in @professions
        profession.count = keyCounts[profession.name] if keyCounts[profession.name]?
    saveProfessionCounts: () ->
      localStorage.setItem('professionCounts', JSON.stringify(@professionCounts))

    loadSpecialGenes: () ->
      rawGenes = localStorage.getItem('specialGenes')
      genes = if rawGenes? then JSON.parse(rawGenes) else {}
      for gene in @specialGenes
        gene.acquired = genes[gene.name]?
    saveSpecialGenes: () ->
      localStorage.setItem('specialGenes', JSON.stringify(@specialGenesAcquired))

</script>


<style lang='sass' scoped>
@import '~bulma/sass/utilities/_all'

h3
  font-size: 4rem
  text-align: center

.statistics
  font-size: 2rem
  text-align: center

.gallery
  display: flex
  flex-wrap: wrap
  justify-content: center

  .page
    display: inline-block
    padding: .5rem .5rem 1rem

    .page-label
      font-size: 2rem
      text-align: center

    .row
      margin-bottom: .5rem
      position: relative
      display: flex
      flex-direction: row

      .profession-placeholder
        align-items: center
        display: inline-flex
        flex-direction: column
        height: 10rem
        width: 10rem

.special-genes
  font-size: 2rem
  line-height: 1.5rem
  padding-bottom: 4rem
  text-align: center

  input
    margin-right: .5rem

.pending-professions
  font-size: 2rem
  padding-bottom: 4rem
  text-align: center

.buildings
  font-size: 2rem

  .column
    align-items: center
    display: inline-flex
    flex-direction: column

</style>
