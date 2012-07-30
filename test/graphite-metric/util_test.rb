require_relative '../test_helper'
require 'graphite-metric/util'

include TestHelpers

module GraphiteMetric
  describe Util do
    describe "float" do
      it "converts string" do
        Util.float("1.8008138").must_equal 1.8008138
      end

      it "converts integer" do
        converted = Util.float(1)
        converted.must_be_instance_of Float
        converted.to_s.must_equal "1.0"
      end

      it "invalid value becomes 0.0" do
        converted = Util.float("None")
        converted.must_be_instance_of Float
        converted.to_s.must_equal "0.0"
      end
    end

    describe "extract_raw_headers" do
      it "simple metrics" do
        Util.extract_headers("my.metric,1336559725,1336559845,60").must_equal(
          ["my.metric", "1336559725", "1336559845", "60"]
        )
      end

      it "metrics with functions" do
        Util.extract_headers("scale(summarize(my.metric,\"5min\"),0.2),1337772900,1337773500,300").must_equal(
          ["scale(summarize(my.metric,\"5min\"),0.2)", "1337772900", "1337773500", "300"]
        )
      end
    end
  end
end
