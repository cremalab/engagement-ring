Instrument = require 'lib/audio/instrument'
Sequencer   = require 'lib/audio/sequencer'

module.exports = class AudioNotification

  tempo = 260

  constructor: (pattern_input) ->
    @pattern = pattern_input

    if "webkitAudioContext" of window
      @stage = new webkitAudioContext()
      voice = new Instrument @stage,
        type: 2
      @sequence(voice)

  sequence: (source) ->
    sequence = new Sequencer
      tempo: tempo
      sequence: @pattern
      osc: source
      oncomplete: ->
        console.log 'done'
    sequence.start()