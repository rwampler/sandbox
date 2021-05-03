
import * as THREE from 'three'

CAMERA_ANGLE_A = 60
CAMERA_ANGLE_B = 25.25
ZOOM = 10
DELTA_SCALE = 1

export default class Camera
  constructor: () ->
    @three_camera = new THREE.OrthographicCamera(-1, 1, 1, -1, -4096, 4096)

    @aspect_ratio = 1
    @zoom = ZOOM
    @scale = DELTA_SCALE

    @look_at = new THREE.Vector3(0, 0, 0)
    @look_at_delta = new THREE.Vector3(Math.tan(CAMERA_ANGLE_A * Math.PI / 180), Math.tan(CAMERA_ANGLE_B * Math.PI / 180) / Math.cos(CAMERA_ANGLE_A * Math.PI / 180), 1)

    @refresh()

  set_size: (width, height) ->
    @aspect_ratio = width / height
    @update()

  adjust_zoom: (delta) ->
    @zoom -= delta
    @update()

  update: () ->
    @three_camera.left = -@aspect_ratio * @zoom
    @three_camera.right = @aspect_ratio * @zoom
    @three_camera.top = @zoom
    @three_camera.bottom = -@zoom
    @three_camera.updateProjectionMatrix()

  refresh: () ->
    @three_camera.position.set(@look_at.x + DELTA_SCALE * @look_at_delta.x, @look_at.y + DELTA_SCALE * @look_at_delta.y, @look_at.z + DELTA_SCALE * @look_at_delta.z)
    @three_camera.lookAt(@look_at)
    @three_camera.updateProjectionMatrix()
