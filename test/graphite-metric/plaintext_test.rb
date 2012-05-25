require_relative '../test_helper'
require 'graphite-metric/plaintext'

include TestHelpers

module GraphiteMetric
  describe Plaintext do
    it "by default timestamp is current utc" do
      Plaintext.new.timestamp.must_equal utc_now
    end

    it "uses the graphite plaintext format when converted to string" do
      "#{Plaintext.new("visitors", 2)}".must_equal "visitors 2 #{utc_now}"
    end

    before do
      @timestamp = Time.now.to_i - 3600
    end

    describe "from hash" do
      before do
        @hash = {
          :key       => "visitors",
          :value     => 2,
          :timestamp => @timestamp
        }
      end

      it "can be built from a hash" do
        "#{Plaintext.from_hash(@hash)}".must_equal "visitors 2 #{@timestamp}"
      end
    end

    describe "from array (of hashes)" do
      before do
        @array = [
          {
            :key       => "visitors",
            :value     => 1,
            :timestamp => @timestamp
          },
          {
            :key   => "visitors",
            :value => 5
          }
        ]
        @graphite_metrics = Plaintext.from_array(@array)
      end

      it "returns an array" do
        @graphite_metrics.must_be_instance_of Array
        @graphite_metrics.size.must_equal 2
      end

      it "each element is a GraphiteMetric::Plaintext" do
        @graphite_metrics.each { |graphite_metric| graphite_metric.must_be_instance_of GraphiteMetric::Plaintext }
      end

      it "converts into graphite plaintext format" do
        @graphite_metrics.map(&:to_s).must_equal([
          "visitors 1 #{@timestamp}",
          "visitors 5 #{utc_now}"
        ])
      end
    end
  end
end
