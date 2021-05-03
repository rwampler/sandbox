
import * as THREE from 'three'

ZOOM = 1000
HEIGHT = 30
HEIGHT_OFFSET = 10

SCROLL_SPEED = 50

export default class Camera
  constructor: () ->
    @three_camera = new THREE.PerspectiveCamera( 5, 1, 1, 5000 )

    console.log(@three_camera.getFocalLength())
    @look_at = new THREE.Vector3(0, HEIGHT_OFFSET, 0)

    @left_scroll_event = null
    @right_scroll_event = null

    @height = HEIGHT
    @zoom = ZOOM

    @refresh()

  start_left_scroll: () ->
    return if @left_scroll_callback?
    @stop_right_scroll() if @right_scroll_callback?
    @left_scroll_callback = (delta) =>
      @look_at.x -= (SCROLL_SPEED * delta)
      @refresh()
  stop_left_scroll: () ->
    @left_scroll_callback = null if @left_scroll_callback?

  start_right_scroll: () ->
    return if @right_scroll_callback?
    @stop_left_scroll() if @left_scroll_callback?
    @right_scroll_callback = (delta) =>
      @look_at.x += (SCROLL_SPEED * delta)
      @refresh()
  stop_right_scroll: () ->
    @right_scroll_callback = null if @right_scroll_callback?

  set_size: (width, height) ->
    @three_camera.aspect = width / height
    @three_camera.updateProjectionMatrix()

  set_focal: (delta) ->
    @zoom += delta
    console.log @zoom
    @refresh()

  tick: (delta) ->
    if @right_scroll_callback?
      @right_scroll_callback(delta)
    else if @left_scroll_callback?
      @left_scroll_callback(delta)

  refresh: () ->
    @three_camera.position.set(@look_at.x, @look_at.y + @height, @look_at.z + @zoom)
    @three_camera.lookAt(@look_at)
