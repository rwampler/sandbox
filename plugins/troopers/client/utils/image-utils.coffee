
export default class ImageUtils

  @data_from_image: (image) ->
    canvas = document.createElement('canvas')
    canvas.width = image.width
    canvas.height = image.height

    context = canvas.getContext('2d')
    context.drawImage(image, 0, 0)

    context.getImageData(0, 0, image.width, image.height)

# function getPixel( imagedata, x, y ) {
#
#     var position = ( x + imagedata.width * y ) * 4, data = imagedata.data;
#     return { r: data[ position ], g: data[ position + 1 ], b: data[ position + 2 ], a: data[ position + 3 ] };
#
# }
