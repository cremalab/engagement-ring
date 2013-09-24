CollectionView = require 'views/base/collection-view'
AutocompleteInput = require 'views/form_elements/autocomplete_input'
TagView = require 'views/form_elements/tag_view'
AutocompleteList = require 'views/form_elements/autocomplete_list'
Tag = require 'models/tag'
template = require './templates/tag_list_input'


module.exports = class TagListInput extends AutocompleteInput
  template: template
  className: 'tag-list'
  events:
    'click button': 'save'
  listen:
    "add collection": "checkLimit"
    "reset collection": "checkLimit"
    "remove collection": "checkLimit"

  initialize: (options) ->
    super
    @TagModel = options.tag_model
    @model = options.model
    @attr = options.attr
    @saveable = options.saveable
    @cancellable = options.cancellable
    @arrayed = options.arrayed
    @model_collection = options.model_collection
    @collection_view = options.collection_view
    if options.label == false
      @label = false
    else
      @label = options.label || 'Tags'
    @listenTo @collection, 'add', @createTagList
    @listenTo @collection, 'remove', @createTagList
    @limit = options.limit if options and options.limit
    @tagTemplate = options.tag_template if options and options.tag_template
    @existing_only = options.existing_only if options and options.existing_only
    @createTagList()

  render: ->
    super
    @delegate 'keyup', 'input', @handleKeys
    if @cancellable or @saveable
      if @cancellable
        @$el.append("<a class='cancel' href='#'>cancel</a>")
      @delegate 'click', '.cancel', @remove

  handleKeys: (e) ->
    if e.keyCode == 13
      e.preventDefault()
      e.stopPropagation()
      val = $(e.target).val()
      unless val is '' or @existing_only is true
        tag = new @TagModel()
        tag.set('autocomplete_value', val).set('autocomplete_search', val)
        @addTag tag
  addTag: (match) ->
    tag = new @TagModel()
    tag.set match.attributes
    normalized_name = tag.get('autocomplete_value')
    existing = @collection.findWhere({autocomplete_value: normalized_name})
    if existing
      existing_view = _.find @getItemViews(), (view) ->
        view.model.cid == existing.cid
      existing_view.$el.addClass('existing')
    else
      @collection.push tag
    @$el.find('input').val('')
    @matches_collection.reset()
    @autocomplete_list.active = false

  save: (e)->
    e.preventDefault()
    orig_model = @model
    @model.save @model.attributes,
      success: (model,res) =>
        @model_collection.add(model)
        @dispose()
      error: (res) ->
        console.log res

  checkLimit: ->
    if @limit
      if @collection.length > (@limit - 1)
        if @cancellable
          @$el.find("input.tag-input").remove()
        else
          @$el.find("input.tag-input").hide()
      else
        @$el.find("input.tag-input").show()
  createTagList: ->
    if @cancellable
      @$el.find('.cancel').remove()
    tags = _.map @collection.models, (tag) ->
      return tag.get('autocomplete_value')
    tags = tags.join(",") unless @arrayed
    @model.set(@attr, tags) if @model

  initItemView: (model)->
    if @tagTemplate
      new TagView
        model: model
        template: @tagTemplate
        tagName: 'div'
    else
      new TagView(model: model)