# Base model.
module.exports = class Model extends Chaplin.Model
  save: (model_attr) ->
    auth = Chaplin.mediator.user.get('auth')
    model_attr.auth = auth
    super
    delete model_attr.auth