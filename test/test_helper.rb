require 'bundler'
Bundler.setup
require 'pry'
require 'turn/autorun'

module TestHelpers
  def utc_now
    Time.now.utc.to_i
  end
end
