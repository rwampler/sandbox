
KEYCODES = {
  32: 'space'
  37: 'left_arrow'
  39: 'right_arrow'
  65: 'a'
  68: 'd'
}

export default class Keyboard
  constructor: () ->
    document.addEventListener "keydown", ((event) => @keydown(event)), false
    document.addEventListener "keyup", ((event) => @keyup(event)), false

    @active_keys = {
      SPACE: false
    }

    @listeners = {
      keypress: []
      keydown: []
      keyup: []
    }

  keydown: (event) ->
    if KEYCODES[event.keyCode]?
      @active_keys[event.keyCode] = true
      @notify_keydown(KEYCODES[event.keyCode])

  keyup: (event) ->
    if @active_keys[event.keyCode]
      @active_keys[event.keyCode] = false
      @notify_keyup(KEYCODES[event.keyCode])
      @notify_keypress(KEYCODES[event.keyCode])

  subscribe_keypress: (callback) -> @listeners.keypress.push callback
  notify_keypress: (key) -> listener(key) for listener in @listeners.keypress

  subscribe_keydown: (callback) -> @listeners.keydown.push callback
  notify_keydown: (key) -> listener(key) for listener in @listeners.keydown

  subscribe_keyup: (callback) -> @listeners.keyup.push callback
  notify_keyup: (key) -> listener(key) for listener in @listeners.keyup
