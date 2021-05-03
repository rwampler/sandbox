<template lang='pug'>
#application-body.container
  .heatmap-context-time
    chart(:options='heatmap_context_time_options' :initOptions='heatmap_context_time_init_options' auto-resize)
</template>

<script lang='coffee'>
DAY_INDICES = { M: 0, T: 1, W: 2, R: 3, F: 4, SA: 5, SU: 6 }

add_style = (original_values) ->
  values = []
  values.push {
    value: value
    textStyle:
      fontSize: 16
      color: '#FFF'
  } for value in original_values
  values

export default
  layout: 'iasip'
  head:
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/iasip/favicon.ico' }
    ]

  created: ->
    request = new XMLHttpRequest()
    request.open('GET', '/iasip/episodes.json', true)
    request.onload = () =>
      day_times = []
      if request.status >= 200 && request.status < 400
        for episode in (JSON.parse(request.responseText).episodes || [])
          continue if episode.context.day == 'U'
          day_index = DAY_INDICES[episode.context.day]
          hour_index = episode.context.time.split(':')[0]
          day_times[day_index] = [] unless day_times[day_index]?
          day_times[day_index][hour_index] = 0 unless day_times[day_index][hour_index]?
          day_times[day_index][hour_index] += 1

      values = []
      for day_index,time_counts of day_times
        for hour_index,count of time_counts
          values.push [+day_index, 23 - +hour_index, count]
      @heatmap_context_time_options.series[0].data = values
    request.send()

  data: ->
    context_time_data: []

    heatmap_context_time_init_options:
      height: '600'
      width: 'auto'

    heatmap_context_time_options:
      tooltip:
        position: 'top'
      legend:
        show: false
      animation: false
      grid:
        height: '95%'
        y: '0%'
        x: '15%'
      xAxis:
        type: 'category'
        data: add_style(['Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'])
        splitArea:
          show: true
      yAxis:
        type: 'category'
        data: add_style(['12a', '1a', '2a', '3a', '4a', '5a', '6a', '7a', '8a', '9a','10a','11a', '12p', '1p', '2p', '3p', '4p', '5p', '6p', '7p', '8p', '9p', '10p', '11p'].reverse())
        splitArea:
          show: true
      visualMap:
        show: false
        min: 0
        max: 10
      series: [{
        type: 'heatmap'
        legend:
          show: false
        data: []
        label:
          normal:
            show: true
        itemStyle:
          emphasis:
            shadowBlur: 10
            shadowColor: 'rgba(0, 0, 0, 0.5)'
      }]
</script>

<style lang='sass' scoped>
p
  margin-bottom: 3rem

.heatmap-context-time
  position: relative
  margin-bottom: 2rem
</style>
