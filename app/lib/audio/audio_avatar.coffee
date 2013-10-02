AvatarScale    = require 'lib/audio/scales/avatar'

module.exports = class AudioAvatar
  constructor: (string) ->
    @input = string
    @scale = AvatarScale
    @scale_length = _.keys(@scale).length

    @sequence = @generateSequence()

  generateScore: (letters) ->
    i = 0
    for letter in letters
      letter = letter.toUpperCase()
      i += letter.charCodeAt()-65
    return i

  generateSequence: ->

    names = @input.split(' ')
    scale_notes = _.keys(@scale)
    sequence = []

    if names[0]
      first_name_letters = names[0].split('') if names[0]
      first_name_sum = @generateScore(first_name_letters)
      note1 = first_name_sum % @scale_length

      sequence.push
        note: scale_notes[note1]
        duration: 'sixteenth'

    if names[1]
      last_name_letters  = names[1].split('')
      halfway = parseInt(last_name_letters.length / 2)
      first_half = last_name_letters.slice(0, halfway)
      last_half  = last_name_letters.slice(halfway, last_name_letters.length)

      first_half_sum = @generateScore(first_half)
      last_half_sum = @generateScore(last_half)

      note2 = first_half_sum % @scale_length
      note3 = last_half_sum  % @scale_length

      sequence.push
        note: scale_notes[note2]
        duration: 'sixteenth'
      sequence.push
        note: scale_notes[note3]
        duration: 'sixteenth'

    return sequence