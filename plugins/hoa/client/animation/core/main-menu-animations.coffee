import anime from 'animejs/lib/anime.es.js'

export default class MainMenuAnimations
  constructor: (@state_manager, @manager) ->

  initialize_menu_dom: (dom) -> @dom_menu = dom
  initialize_menu_actions_dom: (dom) -> @dom_menu_actions = dom

  initialize: () ->
    @next_state_loading = null

    @animation_show_menu = anime({
      targets: @dom_menu
      easing: 'easeInOutQuad'
      autoplay: false
      duration: 4000
      opacity: 1
    })

    @animation_collapse = anime({
      targets: @dom_menu_actions
      easing: 'easeInOutQuad'
      autoplay: false
      duration: 1000
      translateY: '-100%'
    })
    @animation_expand = anime({
      targets: @dom_menu_actions
      easing: 'easeInOutQuad'
      autoplay: false
      duration: 1000
      translateY: 0
    })

    @animation_collapse.finished.then () =>
      @state_manager.state.loading = @next_state_loading if @next_state_loading?
      @next_state_loading = null
      @animation_expand.play()

  show_menu: () ->
    @animation_show_menu.play()

  start_loading: () ->
    return if @state_manager.state.loading
    @next_state_loading = true
    @animation_collapse.play()

  finish_loading: () ->
    console.log "finish #{@state_manager.state.loading}"
    return unless @state_manager.state.loading
    @next_state_loading = false
    @animation_collapse.play()
