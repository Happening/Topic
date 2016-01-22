App = require 'app'
Comments = require 'comments'
Db = require 'db'
Dom = require 'dom'
Form = require 'form'
Icon = require 'icon'
Modal = require 'modal'
Obs = require 'obs'
Page = require 'page'
Photo = require 'photo'
Time = require 'time'
Ui = require 'ui'
{tr} = require 'i18n'

exports.render = !->
	Comments.enable
		invertBar: false
		messages:
			title: (c) ->
				if c.id>1
					tr("%1 changed topic: %2", c.user, c.c)
				else
					tr("%1 started topic: %2", c.user, c.c)

exports.renderSettings = !->
	Form.input
		name: '_title'
		text: tr 'Subject'
		value: App.title()

	Form.condition (values) ->
		tr("A subject is required") if !values._title

	if !Db.shared
		Comments.renderInput
			text: tr("Optional first message")
			photo: true
			name: "commentText"
			snipName: "commentSnip"

