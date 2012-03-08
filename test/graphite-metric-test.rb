require_relative('./test_helper')
require 'graphite-metric'

describe GraphiteMetric do
  it "Plainext has an abbreviated form" do
    GMP.new.must_be_instance_of GraphiteMetric::Plaintext
  end
end
