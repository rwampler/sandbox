
import _ from 'lodash'
import PromisePool from 'es6-promise-pool'
import { Cache, FileLoader, TextureLoader } from 'three'

export default class AjaxTextureLoader

  constructor: () ->
    Cache.enabled = true

    @textureLoader = new TextureLoader()
    @fileLoader = new FileLoader()
    @fileLoader.setResponseType('blob')

  cache_image: (url, objUrl, on_load, on_error) ->
    image = document.createElementNS('http://www.w3.org/1999/xhtml', 'img')
    image.onload = () =>
      Cache.add(url, image)
      URL.revokeObjectURL(objUrl)
      document.body.removeChild(image)
      @textureLoader.load(url, on_load, (() ->), on_error)

    image.src = objUrl
    image.style.display = 'none'
    document.body.appendChild(image)

  load: (url, on_load, on_progress, on_error) ->
    @fileLoader.load(url, ((blob) => @cache_image(url, URL.createObjectURL(blob), on_load, on_error)), on_progress, on_error)

  load_data_url: (name, data_url) ->
    new Promise (done, error) =>
      @cache_image(name, data_url, done, error)

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
