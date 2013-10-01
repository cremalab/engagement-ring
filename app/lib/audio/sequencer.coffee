ChromaticScale = require 'lib/audio/scales/chromatic'

module.exports = class Sequencer

  constructor: (options) ->
    @scale         = options.scale or ChromaticScale
    @instrument    = options.instrument
    @tempo         = options.tempo or 120
    @complete      = options.oncomplete
    @sequence      = options.sequence or []

    @setupDurations()

  setupDurations: ->
    base      = 60000 / @tempo

    whole     = base * 4
    half      = base * 2
    quarter   = base
    eighth    = base / 2
    sixteenth = base / 4

    @durations =
      'whole'    : base
      'half'     : half
      'quarter'  : quarter
      'eighth'   : eighth
      'sixteenth': sixteenth

  start: ->
    if @sequence.length is 0
      throw "Sequencer needs some steps: e.g. [{note: 'G4', duration: 'quarter'}]"
    else
      i    = 0
      @playStep(i)

  playStep: (i) ->
    step = @sequence[i]
    console.log step

    @instrument.playNote @scale[step.note], @durations[step.duration], =>
      i = i + 1
      if i == @sequence.length
        @completeCallback()
      else
        @playStep(i)

  completeCallback: ->
    if @complete
      @complete()


