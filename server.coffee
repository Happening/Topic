App = require 'app'
Comments = require 'comments'
Db = require 'db'
Event = require 'event'

exports.onInstall = exports.onConfig = (config) !->
	if config.commentSnip or config.commentText
		Comments.post
			c: config.commentText
			p: config.commentSnip
			u: App.userId()