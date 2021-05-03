
import * as THREE from 'three'

import ImageUtils from '~/plugins/hoa/client/utils/image-utils.coffee'

WIREFRAME = false

export default class Heightmap
  constructor: (@image, @layer_1_texture, @layer_2_texture) ->
    @image_data = ImageUtils.data_from_image(@image)
    texture = new THREE.DataTexture(new Uint8Array(@image_data.data.buffer), @image_data.width, @image_data.height, THREE.RGBAFormat)
    texture.wrapS = texture.wrapT = THREE.RepeatWrapping
    texture.needsUpdate = true

    @layer_1_texture.wrapS = THREE.RepeatWrapping
    @layer_1_texture.wrapT = THREE.RepeatWrapping
    @layer_1_texture.repeat.set( 8, 8 )

    # material = new LandscapeShader(0x0000ff, @layer_1_texture, @layer_2_texture)
    material = new THREE.MeshLambertMaterial
      color: if WIREFRAME then 0x000000 else 0xC2B280
      map: @layer_1_texture
      wireframe: WIREFRAME

    color_at_position = (x, y) =>
      #@image_data.width, @image_data.height, @image_data.width, @image_data.height)
      @image_data.data[(y * @image_data.width + x) * 4]

    FLOOR_SIZE = 256

    @floor_geometry = new THREE.PlaneBufferGeometry(FLOOR_SIZE, FLOOR_SIZE, FLOOR_SIZE, FLOOR_SIZE)
    @floor_geometry.rotateX(-Math.PI / 2)

    vertices = @floor_geometry.attributes.position.array
    for index in [0...vertices.length] by 3
      pos_x = vertices[index + 0] + FLOOR_SIZE/2
      pos_y = vertices[index + 2] + FLOOR_SIZE/2
      vertices[index + 1] = (color_at_position(pos_x, pos_y) / 256) * 32 - 64

    # console.log vertices
    # console.log @image_data.data
    #vertices[(index * 3) + 1] = @image_data.data[index] for index in [0...vertices.length]

    @mesh = new THREE.Mesh(@floor_geometry, material)


# function getPixel( imagedata, x, y ) {
#
#     var position = ( x + imagedata.width * y ) * 4, data = imagedata.data;
#     return { r: data[ position ], g: data[ position + 1 ], b: data[ position + 2 ], a: data[ position + 3 ] };
#
# }
#
# var imagedata = getImageData( imgTexture.image )
