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
	ownerId = Plugin.ownerId()

	Dom.div !->
		Dom.style backgroundColor: '#fff', margin: '-4px -8px', padding: '8px', borderBottom: '2px solid #ccc'

		Dom.div !->
			Dom.style display_: 'box'
			Ui.avatar Plugin.userAvatar(ownerId)
			
			Dom.h1 !->
				Dom.style display: 'block', _boxFlex: 2, marginLeft: '10px'
				Dom.text shared.get('subject')
		Dom.div !->
			Dom.style margin: '0 0 0 56px'
			Dom.richText shared.get('text')

			Dom.div !->
				Dom.style
					fontSize: '70%'
					color: '#aaa'
					padding: '6px 0 0'
				Dom.text Plugin.userName(ownerId)
				Dom.text " • "
				Time.deltaText Plugin.created()

	Dom.div !->
		Dom.style margin: '0 -8px'
		require('social').renderComments 'comments'
	###
	Dom.div !->
		Dom.style margin: '8px 0'
		shared.ref('comments')?.iterate (comment) !->
			Dom.div !->
				Dom.style
					display_: 'box'
					_boxAlign: 'center'

				Ui.avatar Plugin.userAvatar(comment.get('userId'))

				Dom.section !->
					Dom.style
						_boxFlex: 1
						marginLeft: '8px'
						margin: '4px'
					Dom.text comment.get('comment')
					Dom.div !->
						Dom.style
							textAlign: 'left'
							fontSize: '70%'
							color: '#aaa'
							padding: '2px 0 0'
						Dom.text Plugin.userName(comment.get('userId'))
						Dom.text " • "
						Time.deltaText comment.get('time')

	editingItem = Obs.create(false)
	Dom.div !->
		Dom.style display_: 'box', _boxAlign: 'center', marginTop: '8px'

		Ui.avatar Plugin.userAvatar()

		addE = null
		save = !->
			return if !addE.value().trim()
			Server.sync 'addComment', addE.value().trim()
			addE.value ""
			editingItem.set(false)
			Form.blur()

		Dom.section !->
			Dom.style display_: 'box', _boxFlex: 1, _boxAlign: 'center', margin: '4px'
			Dom.div !->
				Dom.style _boxFlex: 1
				log 'rendering form.text'
				addE = Form.text
					autogrow: true
					name: 'comment'
					text: tr("Add a comment")
					simple: true
					onChange: (v) !->
						editingItem.set(!!v?.trim())
					onReturn: save
					inScope: !->
						Dom.prop 'rows', 1
						Dom.style
							border: 'none'
							width: '100%'
							fontSize: '100%'

			Ui.button !->
				Dom.style
					marginRight: 0
					visibility: (if editingItem.get() then 'visible' else 'hidden')
				Dom.text tr("Add")
			, save
	###

exports.renderSettings = !->
	Form.input
		name: 'subject'
		text: tr 'Subject'
		value: Db.shared.func('subject') if Db.shared

	Form.text
		name: 'text'
		text: tr 'Text'
		autogrow: true
		value: Db.shared.func('text') if Db.shared
		inScope: !-> Dom.prop 'rows', 1
