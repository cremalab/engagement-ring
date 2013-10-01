module.exports = class Instrument
  constructor: (context, options) ->
    @context = context
    @type    = options.type

  createOsc: ->
    osc = @context.createOscillator()
    osc.type = @type or 0
    osc.connect(@context.destination)
    return osc

  playNote: (freq, duration, callback) ->
    @osc = @createOsc()
    @osc.frequency.value = freq or 440
    @osc.noteOn(0)
    length = setTimeout =>
      @stop()
      callback()
      clearTimeout(length)
    , duration

  stop: ->
    @osc.noteOff(0)
    @osc.disconnect()