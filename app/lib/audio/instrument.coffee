VCA = require 'lib/audio/vca'
EnvelopeGenerator = require 'lib/audio/envelope_generator'

module.exports = class Instrument
  constructor: (context, options) ->
    @context = context
    @type    = options.type
    @bus     = options.bus

  createOsc: ->
    osc = @context.createOscillator()
    osc.type = @type or 0
    @polyfill(osc) unless osc.start
    @createEnvelope(osc)
    return osc

  createEnvelope: (osc) ->
    @vca = new VCA(@context)
    @envelope = new EnvelopeGenerator(@context)

    osc.connect(@vca.input)
    @envelope.connect(@vca.amplitude)


  connect: ->
    if @bus
      @vca.connect(@bus.input)
    else
      @vca.connect(@context.destination)

  playNote: (freq, duration, callback) ->
    unless freq is -1
      @osc = @createOsc()
      @osc.frequency.value = freq or 440
      @connect()
      @osc.start(0)
      @envelope.trigger()

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