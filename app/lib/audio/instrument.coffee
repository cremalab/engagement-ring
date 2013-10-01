module.exports = class Instrument
  constructor: (context, options) ->
    @context = context
    @type    = options.type

  createOsc: ->
    osc = @context.createOscillator()
    osc.type = @type or 0
    osc.connect(@context.destination)

    @polyfill(osc) unless osc.start

    return osc

  playNote: (freq, duration, callback) ->
    unless freq is -1
      @osc = @createOsc()
      @osc.frequency.value = freq or 440
      @osc.start(0)

    length = setTimeout =>
      @stop()
      callback()
      clearTimeout(length)
    , duration

  stop: ->
    if @osc
      @osc.stop(0)
      @osc.disconnect()

  polyfill: (osc) ->
    # Safari 6.0.5 uses outdated method names.
    # Chrome uses the most current ones. This
    # is a polyfill for Safari

    osc.start = (t) ->
      osc.noteOn(t)
    osc.stop  = (t) ->
      osc.noteOff(t)