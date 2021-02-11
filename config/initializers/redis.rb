require 'redis'

uri = URI.parse("http://localhost:6379")
REDIS = Redis.new(host: uri.host, port: uri.port)