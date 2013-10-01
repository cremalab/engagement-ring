module.exports = class Sequencer

  # C Major Scale
  notes =
    "C4": 261.63
    "D4": 293.66
    "E4": 329.63
    "F4": 349.23
    "G4": 392.00
    "A4": 440.00
    "B4": 493.88

  constructor: (options) ->
    @osc           = options.osc
    @tempo         = options.tempo or 120
    @pattern_input = options.pattern_input
    @options       = options
    @setupDurations()
    @createSequence()

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

  createSequence: ->

    # Demo sequence for now. Will be generated
    # from @pattern_input somehow.

    @sequence = [
      note: "C4", duration: "quarter"
    ,
      note: "G4", duration: 'half'
    ,
      note: "E4", duration: 'whole'
    ,
      note: "C4", duration: 'whole'
    ,
      note: "D4", duration: 'eighth'
    ,
      note: "E4", duration: 'eighth'
    ,
      note: "F4", duration: 'quarter'
    ,
      note: "E4", duration: 'quarter'
    ]

  start: ->
    i    = 0
    @playStep(i)

  playStep: (i) ->
    step = @sequence[i]
    @osc.playNote notes[step.note], @durations[step.duration], =>
      i = i + 1
      if i == @sequence.length
        @completeCallback()
      else
        @playStep(i)

  completeCallback: ->
    if @options.complete
      @options.complete()


