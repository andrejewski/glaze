// Generated by CoffeeScript 1.6.3
(function() {
  var expireTime, memcached;

  memcached = require('memcache');

  module.exports = Interface;

  Interface.init = function(options, next) {
    var host, port;
    port = options.port, host = options.host;
    this.client = new memcached.Client(port, host);
    this.client.connect();
    return next();
  };

  Interface.write = function(model, key, value, next) {
    return this.client.set(key, value, next, expireTime(model));
  };

  Interface.read = function(key) {
    return this.client.get(key, function(err, results) {
      if (results === 'NOT_STORED') {
        return next(false);
      } else {
        return next(err, results);
      }
    });
  };

  expireTime = function(model) {
    return model.get('expire' || 1000 * 30);
  };

}).call(this);
