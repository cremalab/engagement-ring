Model = require 'models/base/model'

module.exports = class NotificationSetting extends Model
  defaults:
    vote: false
    idea: false
    idea_thread: false
    sound: false