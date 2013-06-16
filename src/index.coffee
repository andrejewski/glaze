# index.coffee
# init: chris andrejewski 6/8/2013

module.exports = 
	Cache : require './cache'
	Redis : ->
		require './redis'
	Memcached : ->
		require './memcached'




