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
      pattern_input: @pattern # String to be converted to pattern
      osc: source
      complete: ->
        console.log 'done'
    sequence.start()