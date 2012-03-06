module GraphiteMetric
  module Util
    extend self

    def from_hash(hash)
      metric = new
      members.each { |member| metric[member] = hash[member] if hash.has_key?(member) }
      metric
    end

    def from_array(array)
      array.inject([]) do |result, hash|
        result << from_hash(hash)
      end
    end
  end
end
