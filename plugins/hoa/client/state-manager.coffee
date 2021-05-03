import Vue from 'vue'

export default class StateManager
  constructor: () ->

    @state = Vue.observable({
      loading: false

      initialized: false
      initialized_dom_animations: false
      initialized_assets: false
      initialized_client: false

      status_loading: null
      status_animation: null
      status: 'initializing'
    })

    @watcher_instance = new Vue({ data: @state })
    @watcher_instance.$watch('initialized_dom_animations', (value) => @update_initialized())
    @watcher_instance.$watch('initialized_assets', (value) => @update_initialized())
    @watcher_instance.$watch('initialized_client', (value) => @update_initialized())

    @watcher_instance.$watch('initialized', (value) => @update_status())

  add_watcher: (type, callback) -> @watcher_instance.$watch(type, callback)

  initialize_dom_animations: (initialized) -> @state.initialized_dom_animations = true
  initialize_assets: (initialized) -> @state.initialized_assets = true
  initialize_client: (initialized) -> @state.initialized_client = true

  start_load: (type) ->
    return false if @state.loading || @state.status_loading?
    @state.status_loading = type
    @state.loading = true
  finish_load: (type) ->
    return false unless @state.loading && @state.status_loading?
    @state.loading = false
    @state.status_loading = null

  start_animation: (type) ->
    return false if @state.status_animation?
    @state.status_animation = type

  update_initialized: () ->
    return if @state.initialized
    @state.initialized = @state.initialized_dom_animations && @state.initialized_assets && @state.initialized_client

  update_status: () -> @state.status = @determine_status()
  determine_status: () ->
    return 'initializing' unless @state.initialized

    'ready'
