Db = require 'db'
Dom = require 'dom'
Modal = require 'modal'
Obs = require 'obs'
Plugin = require 'plugin'
Time = require 'time'
Page = require 'page'
Server = require 'server'
Ui = require 'ui'
Form = require 'form'
{tr} = require 'i18n'

exports.render = !->
	shared = Db.shared
	ownerId = 1

	Dom.div !->
		Dom.style backgroundColor: '#fff', margin: '-4px -8px', padding: '8px', borderBottom: '2px solid #ccc'

		Dom.div !->
			Dom.style display_: 'box'
			Ui.avatar Plugin.userAvatar(ownerId),
				onTap: !-> Plugin.userInfo(ownerId)
			
			Dom.h1 !->
				Dom.style display: 'block', _boxFlex: 2, marginLeft: '10px'
				Dom.text shared.get('subject')
		Dom.div !->
			Dom.style margin: '0 0 0 56px'
			Dom.brText shared.get('text')

			Dom.div !->
				Dom.style
					fontSize: '70%'
					color: '#aaa'
					padding: '6px 0 0'
				Dom.text Plugin.userName(ownerId)
				Dom.text " • "
				Time.deltaText Plugin.created()

	if Db.shared.get('open') ? true
		Dom.div !->
			Dom.style margin: '0 -8px'
			require('social').renderComments
				path: []
				key: 'comments'

exports.renderSettings = !->
	Form.input
		name: 'subject'
		text: tr 'Subject'
		value: Db.shared.func('subject') if Db.shared

	Form.condition (values) ->
		tr("A subject is required") if !values.subject

	Form.text
		name: 'text'
		text: tr 'Text'
		autogrow: true
		value: Db.shared.func('text') if Db.shared
		inScope: !-> Dom.prop 'rows', 1

	Form.sep()
	Form.check
		name: 'open'
		text: tr("Allow comments")
		value: ->
			(Db.shared.get('open') if Db.shared) ? true


