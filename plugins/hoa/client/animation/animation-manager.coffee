import anime from 'animejs/lib/anime.es.js'

import IntroductionAnimations from '~/plugins/hoa/client/animation/core/introduction-animations.coffee'
import MainMenuAnimations from '~/plugins/hoa/client/animation/core/main-menu-animations.coffee'

export default class AnimationManager
  constructor: (@state_manager) ->

    @introduction = new IntroductionAnimations(@state_manager, @)
    @main_menu = new MainMenuAnimations(@state_manager, @)

    @state_manager.add_watcher 'loading', =>
      if @state_manager.state.status_loading == 'core' || @state_manager.state.status_loading == 'game'
        if @state_manager.state.loading
          @start_load()
        else
          @finish_load()


  initialize_intro: (preface_dom, lightning_dom) -> @introduction.initialize_intro(preface_dom, lightning_dom)
  initialize_menu_dom: (dom) -> @main_menu.initialize_menu_dom(dom)
  initialize_menu_actions_dom: (dom) -> @main_menu.initialize_menu_actions_dom(dom)

  initialize: () ->
    @introduction.initialize()
    @main_menu.initialize()
    @state_manager.initialize_dom_animations(true)

  start_introduction: () -> @introduction.start_introduction()
  finish_introduction: () -> @main_menu.show_menu()

  start_load: () -> @main_menu.start_loading()
  finish_load: () -> @main_menu.finish_loading()
