import anime from 'animejs/lib/anime.es.js'

export default class IntroductionAnimations
  constructor: (@state_manager, @manager) ->

  initialize_intro: (preface_dom, lightning_dom) ->
    @dom_preface = preface_dom
    @dom_lightning = lightning_dom

  initialize: () ->
    @timeline_intro = anime.timeline({
      autoplay: false
      easing: 'easeInOutQuad'
    })
    @timeline_intro.add({
      targets: @dom_preface
      opacity: 1
      duration: 2000
      delay: 1000
      endDelay: 1000
    })
    @timeline_intro.add({
      targets: @dom_preface
      opacity: 0
      duration: 2000
      endDelay: 50
    })

    @timeline_intro.add({
      targets: @dom_lightning
      opacity: 0.6
      duration: 70
    })
    @timeline_intro.add({
      targets: @dom_lightning
      opacity: 0.2
      duration: 70
    })
    @timeline_intro.add({
      targets: @dom_lightning
      opacity: 1
      duration: 100
    })
    @timeline_intro.add({
      targets: @dom_lightning
      opacity: 0
      duration: 50,
      complete: (anim) => @manager.finish_introduction()
    })

  start_introduction: () ->
    @timeline_intro.play()
