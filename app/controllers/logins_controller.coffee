Controller = require 'controllers/base/controller'
UserSession = require 'models/user_session'
LoginView = require 'views/logins/login_view'

module.exports = class LoginsController extends Controller
  initialize: ->
    console.log 'login'
  new: ->
    console.log @
    @model = new UserSession()
    @view = new LoginView model: @model, region: 'main'