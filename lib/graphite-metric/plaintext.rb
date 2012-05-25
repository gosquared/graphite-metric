module GraphiteMetric
  Plaintext = Struct.new(:key, :value, :timestamp) do
    def initialize(*args)
      super
      self[:timestamp] ||= Time.now.utc.to_i
    end

    def to_s
      [key, value, timestamp].join(" ")
    end

    def self.from_hash(hash)
      metric = new
      members.each { |member| metric[member] = hash[member] if hash.has_key?(member) }
      metric
    end

    def self.from_array(array)
      array.inject([]) do |result, hash|
        result << from_hash(hash)
      end
    end
  end
end
