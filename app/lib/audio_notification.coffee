# NOTE: CREATE AUDIO CONTEXT IN NOTIFIER

Instrument  = require 'lib/audio/instrument'
Sequencer   = require 'lib/audio/sequencer'
AudioAvatar = require 'lib/audio/audio_avatar'
Chromatic   = require 'lib/audio/scales/chromatic'

module.exports = class AudioNotification

  tempo = 160

  constructor: (context, pattern_input, audio_bus) ->
    @stage = context
    @pattern = pattern_input
    @audio_bus = audio_bus
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
    sequence.start()