# redis.coffee
# init: chris andrejewski 6/8/2013

redis = require redis;

# Interface
module.exports = Interface

Interface.init = (setup, next) ->
	{port, host, options} = setup
	this.client = redis.createClient port, host, options
	next()

Interface.write = (model, key, value, next) ->
	client = this.client
	client.set [key, value], (err, result) ->
		(redis.print err, result) if err
		next err, result

		client.expire key, expireTime model, (err) ->
			(redis.print err, result) if err

Interface.read = (key, next) ->
	client.get key, (err, result) ->
		(redis.print err, result) if err
		# assume err == DNE; must cache now
		if err
			next false
		else
			next err, result

# Helpers

expireTime = (model) ->
	model.get 'expire' || 1000*30; # ms*sec*min*hr*day :: 30secs

