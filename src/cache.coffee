# cache.coffee
# init: chris andrejewski 6/8/2013

_ = require 'underscore'
async = require 'async'
## redis = require 'redis'
db = {}

module.exports = (gif) ->
	db = gif

	class Cache 
		constructor: (@model, @attributes = {}, options) ->
			if (!(this instanceof Cache)) 
				return new Cache(@model, @attributes, @redit);

			db.init options
			
			a = _ @attributes
			@keys = a.keys
			@calc = a.values

			this.attach()

		attach: ->
			operations = ['cache','cast']
			for action in operations
				@model.method action, this[action]()

		# OPERATIONS

		# writes the cache, calls the cast by default
		cache: ->
			cache = this
			return (attributes = cache.keys, next) ->
				model = this

				if _(attributes).isNull() is true
					attributes = cache.attributes

				if typeof attributes is typeof String
					attributes = [attributes]

				if attributes.length is 0
					return next model, null

				# async-ly write cache changes
				async.map attributes, cache.write, (err, changes) ->
					throw err if err
					# finally
					if next
						model.cast next

		# does the actual writing
		write: (attribute, done) ->
			redit = @redis
			model = @model

			key = cacheKey model, attribute

			next = (value) ->
				db.write(model, key, value, done)

			# actually calculate the value
			@attributes[attribute].call @model, next

		# reads values from the cache and updates the model instance
		cast: ->
			cache = this
			return (next) ->
				model = this

				if cache.keys.length is 0
					return next model, null

				# async-ly write cache changes
				async.map cache.keys, cache.read, (err, changes) ->
					throw err if err
					# finally
					if next
						next model, changes

		# does the actual reading
		read: (attribute, done) ->

			cache = this
			redit = @redis
			model = @model

			ckey = cacheKey model, attribute

			next = (err, result) -> 
				model[attribute] = result
				done err, result 

			# get value
			db.read key, (err, result) ->
				if err is false
					cache.write attribute, next
				else
					next err, result

	return Cache


cacheKey = (model, attribute) ->
	model.modelName+':'+model._id+':'+attribute


