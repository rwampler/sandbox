
KEYS = {
  16: 'SHIFT'
  32: 'SPACE'
}

export default class Keyboard
  constructor: () ->
    document.addEventListener "keydown", ((event) => @keydown(event)), false
    document.addEventListener "keyup", ((event) => @keyup(event)), false

    @active_keys = {}

    @listeners = []

  is_pressed_shift: () -> @active_keys['SHIFT'] || false

  keydown: (event) ->
    @active_keys[KEYS[event.keyCode]] = true if KEYS[event.keyCode]

  keyup: (event) ->
    if KEYS[event.keyCode] && @active_keys[KEYS[event.keyCode]]
      @active_keys[KEYS[event.keyCode]] = false
      @notify_keypress(KEYS[event.keyCode])

  subscribe_keypress: (callback) -> @listeners.push callback
  notify_keypress: (key) -> listener(key) for listener in @listeners
