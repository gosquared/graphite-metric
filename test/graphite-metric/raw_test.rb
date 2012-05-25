require_relative '../test_helper'
require 'graphite-metric/raw'

include TestHelpers

module GraphiteMetric
  describe Raw do
    it "converts raw graphite single metric to hashes" do
      gmr = GraphiteMetric::Raw.new(single_metric_raw)
      gmr.metrics.must_equal single_metric_converted
    end

    it "converts raw graphite multiple metrics to hashes" do
      gmr = GraphiteMetric::Raw.new(multiple_metrics_raw)
      gmr.metrics.must_equal multiple_metrics_converted
    end

    it "timeshifts with a positive offset" do
      gmr = GraphiteMetric::Raw.new(single_metric_raw)
      gmr.timeshift(3600).metrics.first[:timestamp].must_equal 1336559725 + 3600
    end

    it "timeshifts with a negatice offset" do
      gmr = GraphiteMetric::Raw.new(single_metric_raw)
      gmr.timeshift(-3600).metrics.first[:timestamp].must_equal 1336559725 - 3600
    end

    it "rounds values" do
      gmr = GraphiteMetric::Raw.new(single_metric_raw)
      gmr.round.metrics.first[:value].must_equal 35
    end

    it "groups metrics by keys" do
      gmr = GraphiteMetric::Raw.new(multiple_metrics_raw)
      gmr.grouped_metrics.must_equal multiple_metrics_grouped
    end

    it "understands metrics with functions" do
      gmr = GraphiteMetric::Raw.new(metric_with_functions_raw)
      gmr.metrics.must_equal metric_with_functions_converted
    end
  end
end
