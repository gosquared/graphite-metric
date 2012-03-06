require 'graphite_metric/util'

module GraphiteMetric
  Plaintext = Struct.new(:key, :value, :timestamp) do
    extend Util

    def initialize(*args)
      super
      self[:timestamp] ||= Time.now.utc.to_i
    end

    def to_s
      [key, value, timestamp].join(" ")
    end
  end
end
