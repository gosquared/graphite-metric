require 'graphite-metric/util'

module GraphiteMetric
  class Raw
    include Util
    attr_reader :raw, :metrics

    def initialize(raw)
      @raw = raw
      populate_from_raw
    end

    def timeshift(offset)
      @metrics.each { |metric| metric[:timestamp] += offset }
      self
    end

    def round
      @metrics.each { |metric| metric[:value] = metric[:value].round }
      self
    end

    # Cannot be chained unlike the previous methods because the
    # @metrics structure gets changed. Not memoizing on purpose, the
    # other methods might modify @metrics.
    def grouped_metrics
      @metrics.inject({}) do |result, metric|
        (result[metric[:key]] ||= []) << {
          :timestamp => metric[:timestamp],
          :value     => metric[:value]
        }
        result
      end
    end

    # It's most efficient to use the raw metrics directly.
    # As of graphite 0.9.10, these values are available in the headers
    # when using cactiStyle function:
    # http://graphite.readthedocs.org/en/0.9.10/functions.html#graphite.render.functions.cactiStyle
    def summary_metrics
      return @summary if @summary

      @summary = {}

      @raw.split("\n").each do |raw|
        raw_headers, raw_metrics = raw.split("|")

        metric_name, from, to, step  = extract_headers(raw_headers)
        metrics = raw_metrics.split(",").map { |v| float(v) }

        @summary[metric_name] = {
          :min => metrics.min,
          :max => metrics.max,
          :avg => float(metrics.reduce(:+) / metrics.size).round(3)
        }
      end

      @summary
    end

    def populate_from_raw
      @metrics = []
      @raw.split("\n").each do |raw|
        raw_headers, raw_metrics = raw.split("|")

        metric_name, from, to, step  = extract_headers(raw_headers)

        current_step = 0
        raw_metrics.split(",").each do |raw_metric|
          @metrics << {
            :key       => metric_name,
            :timestamp => from.to_i + current_step,
            :value     => float(raw_metric)
          }
          current_step += step.to_i
        end
      end
      self
    end
  end
end
