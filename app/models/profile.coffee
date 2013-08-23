Model = require '/models/base/model'

module.exports = class Profile extends Model
  defaults:
    first_name: null
    last_name:  null
    avatar_url: null
    position: null
    employed_on: null
    employment_score: 0
    employer: "Cremalab"

  urlRoot: '/profiles'