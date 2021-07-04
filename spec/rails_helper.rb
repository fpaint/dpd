ENV['MONGOID_ENV'] = 'test'
Mongoid.load!(File.expand_path("dummy/mongoid.yml", __dir__))