require_relative '../test_helper'
require 'graphite_metric/plaintext'

include TestHelpers

module GraphiteMetric
  describe Plaintext do
    before do
      @timestamp = Time.now.to_i - 3600
    end

    it "by default timestamp is current utc" do
      Plaintext.new.timestamp.must_equal utc_now
    end

    it "uses the graphite plaintext format when converted to string" do
      "#{Plaintext.new("visitors", 2)}".must_equal "visitors 2 #{utc_now}"
    end
  end
end
