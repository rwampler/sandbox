
###
global addResizeListener
###

import Camera from '~/plugins/troopers/client/camera.coffee'
import Keyboard from '~/plugins/troopers/core/input-handler/keyboard.coffee'

import Stats from 'stats.js'
import * as THREE from 'three'
import { EffectComposer, EffectPass, PixelationEffect, RenderPass, SMAAEffect } from 'postprocessing'


export default class Client
  constructor: () ->
    @clock = new THREE.Clock()
    @fps = new Stats()

    @initialized = false

    listener = new Keyboard()
    listener.subscribe_keypress (key) =>
      if key == 'space'
        @camera.set_focal(5)

    listener.subscribe_keydown (key) =>
      if key == 'a' || key == 'left_arrow'
        @camera.start_left_scroll()
      else if key == 'd' || key == 'right_arrow'
        @camera.start_right_scroll()

    listener.subscribe_keyup (key) =>
      if key == 'a' || key == 'left_arrow'
        @camera.stop_left_scroll()
      else if key == 'd' || key == 'right_arrow'
        @camera.stop_right_scroll()


  load_and_initialize: () ->
    @load_assets().then => @initialize()

  load_assets: () ->
    Promise.all [
      new Promise (done, error) =>
        @smaa_search = new Image()
        @smaa_search.addEventListener "load", => done()
        @smaa_search.src = SMAAEffect.searchImageDataURL
      , new Promise (done, error) =>
        @smaa_area = new Image()
        @smaa_area.addEventListener "load", => done()
        @smaa_area.src = SMAAEffect.areaImageDataURL
    ]

  initialize: () ->
    container = document.getElementById("render-container")
    container.appendChild(@fps.dom)

    height = container.offsetHeight
    width = container.offsetWidth
    aspect = width / height

    @camera = new Camera()

    @renderer = new THREE.WebGLRenderer()
    @renderer.setClearColor( 0x00ffff, 1 )
    @renderer.gammaOutput = true
    @renderer.gammaFactor = 2.2

    @scene = new THREE.Scene()
    @scene_normal = new THREE.Scene()

    @composer = new EffectComposer(@renderer)

    render_pass = new RenderPass(@scene, @camera.three_camera)
    render_pass.clear = true
    render_pass.renderToScreen = false

    smaa_effect = new SMAAEffect(@smaa_search, @smaa_area)
    smaa_pass = new EffectPass(@camera.three_camera, smaa_effect)
    smaa_pass.renderToScreen = true

    @composer.addPass(render_pass)
    @composer.addPass(smaa_pass)

    mesh_material = new THREE.MeshPhongMaterial
      color: 0x51575C
      specular: 0xFFFFFF
      shininess: 10

    WIDTH = 10
    DEPTH = 150
    DEPTH_OFFSET = -200

    BUILDING_WIDTH = 4
    BUILDING_HEIGHT = 10
    BUILDING_SPACING = 2

    for x in [0..WIDTH]
      for z in [0..DEPTH]
        continue if Math.random() > 0.2
        x_pos = (x - WIDTH * 0.5) * (BUILDING_WIDTH + BUILDING_SPACING - x % 2)
        z_pos = (z - DEPTH * 0.5) * (BUILDING_WIDTH + BUILDING_SPACING - z % 2) + DEPTH_OFFSET

        mesh = new THREE.Mesh(new THREE.BoxGeometry(BUILDING_WIDTH, BUILDING_HEIGHT, BUILDING_WIDTH), mesh_material)
        mesh.position.set(x_pos, 0, z_pos)
        @scene.add(mesh)

    mesh_material = new THREE.MeshPhongMaterial
      color: 0x00FF00
      specular: 0xFFFFFF
      shininess: 10

    mesh = new THREE.Mesh(new THREE.BoxGeometry(2, 5, 2), mesh_material)
    mesh.position.set(-6, 0, 8)
    @scene.add(mesh)


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

    container.appendChild(@renderer.domElement)

    @handle_resize()
    addResizeListener(container, => @handle_resize())

    @initialized = true

  handle_resize: () ->
    container = document.getElementById("render-container")
    height = container.offsetHeight
    width = container.offsetWidth

    @camera.set_size(container.offsetWidth, container.offsetHeight)
    @renderer.setSize(container.offsetWidth, container.offsetHeight)
    @composer.setSize(container.offsetWidth, container.offsetHeight)

  tick: () ->
    return unless @initialized

    delta = @clock.getDelta()

    @camera.tick(delta)
    @composer.render()
    # @renderer.render(@scene, @camera);

    @fps.update()
