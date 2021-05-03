
import _ from 'lodash'
import PromisePool from 'es6-promise-pool'
import { Cache } from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'

export default class AjaxModelLoader

  constructor: () ->
    Cache.enabled = true
    @gltf_loader = new GLTFLoader()

  load: (url, on_load, on_progress, on_error) ->
    @gltf_loader.load(url, on_load, on_progress, on_error)


  load_model_assets: (gltf_loader) ->
    new Promise (done, error) =>
      Promise.all([
        new Promise (inner_done, inner_error) =>
          gltf_loader.load('/models/stargate.glb', (gltf) =>
            @stargate_standby = gltf.scene.children[0]
            inner_done()
          , undefined, inner_error)
        , new Promise (inner_done, inner_error) =>
          gltf_loader.load('/models/stargate_active.glb', (gltf) =>
            @stargate_active = gltf.scene.children[1]
            inner_done()
          , undefined, inner_error)
      ]).then(done).catch(error)


  load_all: (urls) ->
    new Promise (done, error) =>
      on_progress = (stats) ->
        console.log 'on_progress'
        # console.log stats
      pending_urls = _.clone(urls)
      pool = new PromisePool(() =>
        return null unless pending_urls.length
        new Promise (inner_done, inner_error) => @load(pending_urls.shift(), inner_done, on_progress, inner_error)
      , 5)

      poolPromise = pool.start()
      poolPromise.then(() =>
        console.log('All promises fulfilled')
        done()
      , (err) =>
        console.log('Some promise rejected: ' + err.message)
        error(err)
      )
