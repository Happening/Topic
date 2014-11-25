Db = require 'db'
Plugin = require 'plugin'
Event = require 'event'

exports.onInstall = (config) !->
	if config?
		Db.shared.merge config
		if config.subject
			Event.create
				unit: 'announcement'
				text: "#{Plugin.userName(Plugin.ownerId())} announces: #{config.subject}"
				new: ['all', -Plugin.ownerId()]

exports.onConfig = (config) !->
	Db.shared.merge config

exports.getTitle = ->
	Db.shared.get 'subject'

exports.client_addComment = (comment) !->
	maxCommentId = Db.shared.modify 'maxCommentId', (v) -> (v||0) + 1
	nowTime = Math.round(Date.now()*.001)

	Db.shared.set 'lastEventTime', nowTime
	Db.shared.set 'comments', maxCommentId,
		userId: Plugin.userId()
		time: nowTime
		comment: comment

	Event.create
		unit: 'comment'
		text: "Comment by #{Plugin.userName()}: #{comment}"
		read: [Plugin.userId()]
