# Base model.
module.exports = class Model extends Chaplin.Model
  url: ->
    if window.location.host.indexOf('localhost') == -1
      "http://cremalab-ideas-api.herokuapp.com#{@api_url}"
    else
      @api_url