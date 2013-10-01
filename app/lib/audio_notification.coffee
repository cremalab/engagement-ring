Instrument  = require 'lib/audio/instrument'
Sequencer   = require 'lib/audio/sequencer'
AudioAvatar = require 'lib/audio/audio_avatar'
Bus         = require 'lib/audio/bus'
Chromatic   = require 'lib/audio/scales/chromatic'

module.exports = class AudioNotification

  tempo = 160

  constructor: (pattern_input) ->
    @pattern = pattern_input

    if "webkitAudioContext" of window
      @stage = new webkitAudioContext()
      @audio_bus = new Bus(@stage)
      @audio_bus.connect(@stage.destination)
      @createTone()

  createTone: ->
    voice1 = new Instrument @stage,
      type: 3
      bus: @audio_bus

    avatar = new AudioAvatar(@pattern)

    sequence = new Sequencer
      tempo: tempo
      sequence: avatar.sequence
      scale: avatar.scale
      instrument: voice1
      oncomplete: ->
        console.log 'done'
    sequence.start()

webkitAudioContext::createGain = ->
  if webkitAudioContext.prototype.createGain
    webkitAudioContext.createGain()
  else
    webkitAudioContext.prototype.createGainNode()