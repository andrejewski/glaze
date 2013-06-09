# Glaze
The database-agnostic caching layer for Mongoose.

## How and Why
Glaze was made to work seamlessly with Mongoose in providing a layer of caching on top of the already fast MongoDB. The  concept of Glaze is very simple: a mongoose model has relational data is that either changing to quickly or not best stored to be queued and calculated through only MongoDB. Glaze can theoretically store any data in key-value sense, but was created with realtime(ish) counts, indexes, and joins in mind that can take advantage of the speed of caching.

Glaze is most like a cached data layer; you call for that layer to computed on top of the current Mongoose model and the data is filled in using the provided cache. That's why I named it Glaze.

Glaze is database-agnostic in how it interacts with the caching layer and its own mechanisms. Although Glaze was originally only for Redis caching, Glaze has been reformatted to work with any database that can meet the Glaze Interface Format. See the 'Glaze Interface Format' section for more details as to what is supported and what can be supported by viewers like you.

## Install
Just use NPM 'npm install glaze' in your project directory, use 'npm install glaze -g' if you want to use it anywhere.

## Glazing
To use Glaze, you really only have to migrate your relational Mongoose code into the Glaze.Cache initializer. This is very simple to do:

	 


## Glaze Interface Format

### Current Built-in GIFs
- Redis

### How to GIF
Borrowing from Go (Golang), GIF is any object that meets the following method requirements:

- interface#init:
> (options object)
< returns undefined
This function is called on the initialization of an interface. This is where connection or client of the database should be established and in some way attached to the interface object.

- interface#write:
> (model Mongoose.model, key string, value any, next function)
< next(err error, result any)
This function will write to the database. Glaze assumes a key-value store will be used as most caching databases are, but the function itself can shoe-horn into any database. Glaze won't mind a little customization.

- interface#read:
> (key string, next function)
< next(err error, result any)
This function will read from the database. Glaze assumes a key-value store will be used as most caching databases are, but the function itself can shoe-horn into any database. Glaze won't mind a little customization. You can return 'false' for err and Glaze will calculate the value, add it to the cache, and reread it automatically.

And that is GIF. You can make your own interface and merge it into your own Glaze fork. Send a pull-request and get it added maybe?

