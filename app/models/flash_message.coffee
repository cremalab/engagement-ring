Model = require 'models/base/model'

module.exports = class FlashMessage extends Model
  defaults:
    message: "Something needs your attention"
    lifespan: 5000