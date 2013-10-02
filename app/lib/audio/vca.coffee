module.exports = class VCA
  constructor: (context) ->
    @gain = context.createGainNode()
    @gain.gain.value = 0
    @input = @gain
    @output = @gain
    @amplitude = @gain.gain

  connect: (node) ->
    if node.hasOwnProperty("input")
      @output.connect node.input
    else
      @output.connect node