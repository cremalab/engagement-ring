Model = require '/models/base/model'

module.exports = class IdeaVote extends Model
  defaults:
    idea_id: null       # fk
    user_id: null       # fk
    created_at: null    # datetime
