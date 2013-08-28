Model = require 'models/base/model'

module.exports = class Error extends Model
  defaults:
    text: "Something went wrong"