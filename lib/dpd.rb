require 'mongoid'
require_relative "dpd/version"

module Dpd
  class Error < StandardError; end
end

require 'dpd/railtie' if defined?(Rails)
require 'dpd/models/locality'
require 'dpd/models/terminal'
require 'dpd/client'
require 'dpd/localities'
require 'dpd/terminals'
require 'dpd/convertion'
require 'dpd/region'