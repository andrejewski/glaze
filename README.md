# Glaze
The database-agnostic caching layer for [Mongoose](http://mongoosejs.com/).

## How and Why
Glaze was made to work seamlessly with Mongoose in providing a layer of caching on top of the already fast MongoDB. The  concept of Glaze is very simple: a mongoose model has relational data is that either changing to quickly or not best stored to be queued and calculated through only MongoDB. Glaze can theoretically store any data in key-value sense, but was created with realtime(ish) counts, indexes, and joins in mind that can take advantage of the speed of caching.

Glaze is most like a cached data layer; you call for that layer to computed on top of the current Mongoose model and the data is filled in using the provided cache. That's why I named it Glaze.

Glaze is database-agnostic in how it interacts with the caching layer and its own mechanisms. Although Glaze was originally only for Redis caching, Glaze has been reformatted to work with any database that can meet the Glaze Interface Format. See the 'Glaze Interface Format' section for more details as to what is supported and what can be supported by viewers like you.

## Install
Just use npm's `npm install glaze` in your project directory, use `npm install glaze -g` if you want to use it anywhere.

## Glazing
Configuring glaze to your database should be very straight-forward. Just require Glaze and supply a Cache with a GIF for your database.
``` javascript
var glaze = require('glaze'),
	redis = glaze.Redis(),
	Cache = glaze.Cache(redis);
```
To use Glaze, you really only have to migrate your relational Mongoose code into the Glaze.Cache initializer.
``` javascript
var glazeAttributeHash = {
	propertyName: function(next) { thatWillComputeAValueAndPassItToNext; next(Value) },
	visits: function(next) {
		// `this` is your mongoose model instance just like regular mongoose methods
		// figure out the model's number of visits
		var visits = 3;
		next(visits);
	}
}

var dbInitOptions = {
	// these are pretty spefic to you database, but it should contain port numbers, database names, etc
	// see your database's gif for details
}

Cache(mongooseModel, glazeAttributesHash, dbInitOptions);
```
### Cache and Cast
Now to actually use the dang thing; Glaze exposes two functions on your mongoose model: **cache** and **cast**. 

Cache will write a model's cache, read from the cache, and add the values to the specified attributes from the glazeAttributeHash to the model instance. You can chose specific values to cache this way. Cache calls Cast automatically internally.

Cast will only read the values from the cache and add them to the model. Depending on the caching database's GIF, if cast does not find a value it will call Cache on that one attribute to generate and write it to the cache to then read it on to the model. This insures that a model has its values.

``` javascript
glazedModel.cache('visits', function(model, changes) {
	// use the cached model
	// note that all glaze properties will be included
	// not just the `visits`; though it was recalculated
});

glazedModel.cast(function(model, changes) {
	// the exact same follow-through
});
```

## Glaze Interface Format

### Current Built-in GIFs
- Redis

### How to GIF
Borrowing from Go (Golang), GIF is any object that meets the following method requirements:

- interface#init:
``` javascript
> (options object)
< returns undefined
```
This function is called on the initialization of an interface. This is where connection or client of the database should be established and in some way attached to the interface object.

- interface#write:
``` javascript
> (model Mongoose.model, key string, value any, next function)
< next(err error, result any)
```
This function will write to the database. Glaze assumes a key-value store will be used as most caching databases are, but the function itself can shoe-horn into any database. Glaze won't mind a little customization.

- interface#read:
``` javascript
> (key string, next function)
< next(err error, result any)
```
This function will read from the database. Glaze assumes a key-value store will be used as most caching databases are, but the function itself can shoe-horn into any database. Glaze won't mind a little customization. You can return 'false' for err and Glaze will calculate the value, add it to the cache, and reread it automatically.

And that is GIF. You can make your own interface and merge it into your own Glaze fork. Send a pull-request and get it added maybe?

## Thank You for Using Glaze
If you are using Glaze on a project, contact me on [twitter](http://twitter.com/compooter/) and I'll link to the project here.
