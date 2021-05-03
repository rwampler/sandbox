
import EventListener from '~/plugins/coloniae/core/event-listener.coffee'

export default class Mouse
  constructor: (@tool_state, parent_dom=null) ->
    @event_listener = new EventListener()

    @parent_dom = if parent_dom? then parent_dom else document

    @parent_dom.addEventListener "mousewheel", ((event) => @handle_mousewheel(event)), false
    @parent_dom.addEventListener "DOMMouseScroll", ((event) => @handle_mousewheel(event)), false

    @parent_dom.addEventListener "mousedown", ((event) => @start_moving(event)), false
    @parent_dom.addEventListener "mousemove", ((event) => @do_move(event)), false
    @parent_dom.addEventListener "mouseup", ((event) => @finish_moving(event)), false
    @parent_dom.addEventListener "mouseout", ((event) => @finish_moving(event)), false

    @is_moving = false

    @last_x = -1
    @last_y = -1

  subscribe_mouse_wheel: (listener_callback) -> @event_listener.subscribe('mouse.wheel', listener_callback)
  notify_mouse_wheel: (delta) -> @event_listener.notify_listeners('mouse.wheel', delta)
  subscribe_mouse_click: (listener_callback) -> @event_listener.subscribe('mouse.click', listener_callback)
  notify_mouse_click: (data) -> @event_listener.notify_listeners('mouse.click', data)
  subscribe_mouse_move: (listener_callback) -> @event_listener.subscribe('mouse.move', listener_callback)
  notify_mouse_move: (data) -> @event_listener.notify_listeners('mouse.move', data)

  handle_mousewheel: (event) ->
    delta = Math.max(-1, Math.min(1, (event.wheelDelta || -event.detail)));
    @notify_mouse_wheel(delta) unless delta == 0
    false

  start_moving: (event) ->
    return unless @tool_state.initialized && @tool_state?.status == 'ready'
    @is_moving = true

    @start_x = @last_x = Math.round(event.offsetX)
    @start_y = @last_y = Math.round(event.offsetY)

  finish_moving: (event) =>
    return unless @tool_state.initialized && @tool_state?.status == 'ready' && @is_moving
    @is_moving = false

    @last_x = Math.round(event.offsetX)
    @last_y = Math.round(event.offsetY)

    if @last_x == @start_x && @last_y == @start_y
      mouse_x = ( @last_x / @parent_dom.offsetWidth ) * 2 - 1
      mouse_y = - ( @last_y / @parent_dom.offsetHeight ) * 2 + 1
      @notify_mouse_click({ x:mouse_x, y:mouse_y })

  do_move: (event) =>
    return unless @tool_state.initialized && @tool_state?.status == 'ready' && @is_moving

    event_x = Math.round(event.offsetX)
    event_y = Math.round(event.offsetY)

    delta_x = if @last_x >= 0 then @last_x - event_x else 0
    delta_y = if @last_y >= 0 then @last_y - event_y else 0
    @last_x = event_x
    @last_y = event_y

    @notify_mouse_move({ delta_x:delta_x, delta_y:delta_y })
