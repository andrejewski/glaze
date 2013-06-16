# memcache.coffee
# by Chris Andrejewski

memcached = require 'memcache'

# Interface
module.exports = Interface;

Interface.init = (options, next) ->
	{port, host} = options
	this.client = new memcached.Client port, host
	this.client.connect()
	next()

Interface.write = (model, key, value, next) ->
	this.client.set key, value, next, expireTime model

Interface.read = (key) ->
	this.client.get key, (err, results) ->
		if results is 'NOT_STORED'
			next false
		else
			next err, results

# Helpers

expireTime = (model) ->
	model.get 'expire' || 1000*30; # ms*sec*min*hr*day :: 30secs


