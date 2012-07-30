module GraphiteMetric
  module Util
    extend self

    def float(raw_metric)
      Float(raw_metric)
    rescue
      0.0
    end

    def extract_headers(raw_headers)
      all_splits = raw_headers.split(",")
      step = all_splits.pop
      to = all_splits.pop
      from = all_splits.pop
      metric_name = all_splits.join(",")

      [metric_name, from, to, step]
    end
  end
end
