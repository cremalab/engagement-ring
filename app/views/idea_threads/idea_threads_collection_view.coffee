CollectionView = require 'views/base/collection-view'
IdeaThread = require 'models/idea_thread'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
template = require './templates/collection'

module.exports = class IdeaThreadsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  template: template
  events:
    'click .add': 'newIdeaThread'
  itemView: IdeaThreadView

  newIdeaThread: (e) ->
    if @new_idea_thread
      new_idea_thread_view = @viewForModel(@new_idea_thread)
      new_idea_thread_view.$el.find('input:visible:first').focus()
    else
      @collection.add
        user_id: Chaplin.mediator.user.get('id')
