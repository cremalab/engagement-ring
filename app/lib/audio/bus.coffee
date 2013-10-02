# Inspired by this awesome case study: http://www.html5rocks.com/en/tutorials/casestudies/jamwithchrome-audio/

module.exports = class AudioBus
  constructor: (context) ->
    @input  = context.createGainNode()
    @output = context.createGainNode()

    #create effect nodes (Convolver and Equalizer are other custom effects from the library presented at the end of the article)
    # delay = new SlapbackDelayNode()
    # convolver = new tuna.Convolver()
    # equalizer = new tuna.Equalizer()
    tuna = new Tuna(context)

    delay = new tuna.Delay
      feedback: .3 #0 to 1+
      delayTime: 200 #how many milliseconds should the wet signal be delayed?
      wetLevel: .6 #0 to 1+
      dryLevel: 1 #0 to 1+
      cutoff: 800 #cutoff frequency of the built in highpass-filter. 20 to 22050
      bypass: 0

    filter = new tuna.Filter(
      frequency: 1500 #20 to 22050
      Q: 100 #0.001 to 100
      gain: -40 #-40 to 40
      bypass: 0 #0 to 1+
      filterType: 2 #0 to 7, corresponds to the filter types in the native filter node: lowpass, highpass, bandpass, lowshelf, highshelf, peaking, notch, allpass in that order
    )

    chorus = new tuna.Chorus
      rate: 10.5
      feedback: .6
      delay: 0.085
      bypass: 0


    @input.connect chorus.input
    chorus.connect(filter.input)
    filter.connect(delay.input)
    delay.connect(@output)

  connect: (target) ->
    @output.connect target