require_relative '../test_helper'
require 'graphite-metric/util'

include TestHelpers

module GraphiteMetric
  describe Util do
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
