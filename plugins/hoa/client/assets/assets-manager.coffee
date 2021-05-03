
import { SMAAEffect } from 'postprocessing'
import { Cache } from 'three'

import AjaxModelLoader from '~/plugins/hoa/client/utils/ajax-model-loader.coffee'
import AjaxTextureLoader from '~/plugins/hoa/client/utils/ajax-texture-loader.coffee'

GATE_SCALE = 18

export default class AssetsManager
  constructor: (@state_manager) ->
    @manifests_by_id = {
      core: {
        models: [],
        textures: [
          '/hoa/textures/heightmap.png',
          '/hoa/textures/noise.png'
        ]
      }
    }

    @model_loader = new AjaxModelLoader()
    @texture_loader = new AjaxTextureLoader()

  has_assets: (module_id) ->
    return false unless @manifests_by_id[module_id]?
    for type in ['models', 'textures']
      for key in (@manifests_by_id[module_id]?[type] || [])
        return false unless Cache.get(key)?
    true

  load_assets: (type) ->
    promises = []
    promises.push(@model_loader.load_all(@manifests_by_id[type].models)) if @manifests_by_id[type].models?.length
    promises.push(@texture_loader.load_all(@manifests_by_id[type].textures)) if @manifests_by_id[type].textures?.length

    if type == 'core'
      promises.push @texture_loader.load_data_url('smaa-search', SMAAEffect.searchImageDataURL)
      promises.push @texture_loader.load_data_url('smaa-area', SMAAEffect.areaImageDataURL)

    Promise.all promises
