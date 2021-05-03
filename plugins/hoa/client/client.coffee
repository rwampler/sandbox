
###
global addResizeListener
###

import { BrightnessContrastEffect, ClearPass, EffectComposer, EffectPass, PixelationEffect, RenderPass, SMAAEffect } from 'postprocessing'
import Stats from 'stats.js'
import * as THREE from 'three'
import { MeshText2D, SpriteText2D, textAlign } from 'three-text2d'

import AnimationManager from '~/plugins/hoa/client/animation/animation-manager.coffee'
import AssetsManager from '~/plugins/hoa/client/assets/assets-manager.coffee'

import Camera from '~/plugins/hoa/client/camera.coffee'
import Heightmap from '~/plugins/hoa/client/heightmap.coffee'
import StateManager from '~/plugins/hoa/client/state-manager.coffee'

import Keyboard from '~/plugins/hoa/client/input/keyboard.coffee'
import Mouse from '~/plugins/hoa/client/input/mouse.coffee'

import ImageUtils from '~/plugins/hoa/client/utils/image-utils.coffee'


export default class Client
  constructor: () ->
    @fps = new Stats()
    @clock = new THREE.Clock()

    @renderer = new THREE.WebGLRenderer()
    @renderer.setClearColor(0x000000);
    @renderer.gammaOutput = true
    @renderer.gammaFactor = 2.2

    @camera = new Camera()
    @state_manager = new StateManager()

    @animation_manager = new AnimationManager(@state_manager)
    @assets_manager = new AssetsManager()

    @keyboard_listener = new Keyboard()
    @keyboard_listener.subscribe_keypress (key) =>
      console.log key

    @mouse_listener = new Mouse(@state_manager)
    @mouse_listener.subscribe_mouse_wheel (delta) =>
      @camera.adjust_zoom(delta)

    @loading = true

  initialize_with_dom: (dom_id) ->
    @render_container_dom_id = dom_id

    container = document.getElementById(@render_container_dom_id)
    @renderer.setSize(container.offsetWidth, container.offsetHeight)
    container.insertBefore(@renderer.domElement, container.childNodes[0])
    container.appendChild(@fps.dom)
    addResizeListener(container, => @handle_resize())

    @mouse_listener.initialize_with_dom(container)

  load_and_initialize: () ->
    @state_manager.start_load('core')
    @assets_manager.load_assets('core').then =>
      @initialize()
      @state_manager.finish_load('core')

    @animation_manager.initialize()
    @animation_manager.start_introduction()

  initialize: () ->
    @scene = new THREE.Scene()
    @scene_normal = new THREE.Scene()

    @composer = new EffectComposer(@renderer)

    render_pass = new RenderPass(@scene, @camera.three_camera)
    render_pass.clear = true
    render_pass.renderToScreen = false

    smaa_effect = new SMAAEffect(THREE.Cache.get('smaa-search'), THREE.Cache.get('smaa-area'))
    smaa_pass = new EffectPass(@camera.three_camera, smaa_effect)
    smaa_pass.clear = false
    smaa_pass.renderToScreen = false

    @brightness_effect = new BrightnessContrastEffect({brightness: -1})
    brightness_pass = new EffectPass(@camera, @brightness_effect)
    brightness_pass.clear = false
    brightness_pass.renderToScreen = true

    @composer.addPass(render_pass)
    @composer.addPass(smaa_pass)
    @composer.addPass(brightness_pass)

    avatar_material = new THREE.MeshPhongMaterial
      color: 0x00FF00
      specular: 0xFFFFFF
      shininess: 10

    avatar_mesh = new THREE.Mesh(new THREE.BoxGeometry(.2, 1.75, .5), avatar_material)
    avatar_mesh.position.set(0, 1.25, 0)
    @scene.add(avatar_mesh)

    light_material = new THREE.MeshPhongMaterial
      color: 0xEEEEEE
      specular: 0xFFFFFF
      shininess: 50

    light_1_position = new THREE.Vector3(64, 32, 0)

    light_1 = new THREE.BoxGeometry(1, 1, 1)
    light_1_mesh = new THREE.Mesh(light_1, light_material)
    light_1_mesh.position.set(light_1_position.x, light_1_position.y, light_1_position.z)
    @scene.add(light_1_mesh)

    light = new THREE.PointLight(0x444444, 2, 256)
    light.position.set(light_1_position.x, light_1_position.y, light_1_position.z)
    @scene.add(light)

    @scene.add(new THREE.AmbientLight( 0xF0F0F0 ))

    @handle_resize()
    @state_manager.initialize_client(true)

  handle_resize: () ->
    container = document.getElementById(@render_container_dom_id)
    @camera?.set_size(container.offsetWidth, container.offsetHeight)
    @renderer?.setSize(container.offsetWidth, container.offsetHeight)
    @composer?.setSize(container.offsetWidth, container.offsetHeight)

  set_brightness: () ->
    console.log @brightness_effect
    #@brightness_effect.uniforms.get('brightness').value = 0

  tick: () ->
    #@brightness_effect.uniforms.get('brightness').value = @brightness
    if @state_manager.state.initialized

      @composer.render(@clock.getDelta())
      # @renderer.render(@scene, @camera.three_camera);

    @fps.update()
