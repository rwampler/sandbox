import Vue from 'vue'
import ECharts from 'vue-echarts'
import { use } from "echarts/core"

import {
  HeatmapChart
} from 'echarts/charts'
import {
  SingleAxisComponent,
  GridComponent,
  TitleComponent,
  TooltipComponent,
  VisualMapComponent
} from 'echarts/components'

use([
  HeatmapChart,
  SingleAxisComponent,
  GridComponent,
  TitleComponent,
  TooltipComponent,
  VisualMapComponent
])

Vue.component('chart', ECharts)
