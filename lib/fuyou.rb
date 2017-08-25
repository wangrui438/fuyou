require "fuyou/version"
require "fuyou/configuration"
require "fuyou/base"
require "fuyou/ca"
require "fuyou/member_point"
require "logger"

module Fuyou
  Error                 = Class.new(StandardError)
  InvalidResponseError  = Class.new(Error)
  UnknownError          = Class.new(Error)

  class << self
    def setup
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
