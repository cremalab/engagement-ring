# Inspired by http://blog.chrislowis.co.uk/2013/06/17/synthesis-web-audio-api-envelopes.html

module.exports = class EnvelopeGenerator
  constructor: (context) ->
    @context     = context
    @attackTime  = 0
    @releaseTime = 0.5
    @sustain     = 0
    @decayTime   = 0.06

  trigger: ->
    now = @context.currentTime
    @param.cancelScheduledValues now
    @param.setValueAtTime 0, now
    # Attack
    @param.linearRampToValueAtTime 1, now + @attackTime
    # Decay
    @param.linearRampToValueAtTime @sustain, now + @attackTime + @decayTime
    # Release
    @param.linearRampToValueAtTime 0, now + @attackTime + @decayTime + @releaseTime

  connect: (param) ->
    @param = param