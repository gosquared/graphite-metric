module GraphiteMetric
  class Raw
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

    def populate_from_raw
      @metrics = []
      @raw.split("\n").each do |raw|
        raw_headers, raw_metrics = raw.split("|")

        metric_name, from, to, step  = raw_headers.split(",")

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

    def float(raw_metric)
      Float(raw_metric)
    rescue
      0
    end
  end
end
