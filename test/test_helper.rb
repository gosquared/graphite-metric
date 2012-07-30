require 'pry'
require 'turn/autorun'

BASE_PATH = File.expand_path('../../', __FILE__)

module TestHelpers
  def utc_now
    Time.now.utc.to_i
  end

  def single_metric_raw
    @single_metric_raw ||= File.read("#{BASE_PATH}/test/fixtures/single_metric.txt")
  end

  def single_metric_converted
    [
      {
        :key       => "my.metric",
        :timestamp => 1336559725,
        :value     => 34.999
      },
      {
        :key       => "my.metric",
        :timestamp => 1336559785,
        :value     => 35.10
      },
      {
        :key       => "my.metric",
        :timestamp => 1336559845,
        :value     => 0
      }
    ]
  end

  def single_metric_summarised
    {
      "my.metric" => {
        :min => 0.000,
        :max => 35.100,
        :avg => 23.366
      }
    }
  end

  def multiple_metrics_raw
    @multiple_metrics_raw ||= File.read("#{BASE_PATH}/test/fixtures/multiple_metrics.txt")
  end

  def multiple_metrics_converted
    [
      {
        :key       => "my.first.metric",
        :timestamp => 1336559725,
        :value     => 0
      },
      {
        :key       => "my.first.metric",
        :timestamp => 1336559785,
        :value     => 9.21
      },
      {
        :key       => "my.first.metric",
        :timestamp => 1336559845,
        :value     => 8.333
      },
      {
        :key       => "my.second.metric",
        :timestamp => 1336559725,
        :value     => 1.1
      },
      {
        :key       => "my.second.metric",
        :timestamp => 1336559785,
        :value     => 2.999
      },
      {
        :key       => "my.second.metric",
        :timestamp => 1336559845,
        :value     => 3.50
      }
    ]
  end

  def multiple_metrics_summarised
    {
      "my.first.metric" => {
        :min => 0.000,
        :max => 9.210,
        :avg => 5.848
      },
      "my.second.metric" => {
        :min => 1.100,
        :max => 3.500,
        :avg => 2.533
      }
    }
  end

  def multiple_metrics_grouped
    {
      "my.first.metric" => [
        {
          :timestamp => 1336559725,
          :value     => 0
        },
        {
          :timestamp => 1336559785,
          :value     => 9.21
        },
        {
          :timestamp => 1336559845,
          :value     => 8.333
        }
      ],
      "my.second.metric" => [
        {
          :timestamp => 1336559725,
          :value     => 1.1
        },
        {
          :timestamp => 1336559785,
          :value     => 2.999
        },
        {
          :timestamp => 1336559845,
          :value     => 3.50
        }
      ]
    }
  end

  def metric_with_functions_raw
    @metric_with_functions_raw ||= File.read("#{BASE_PATH}/test/fixtures/metric_with_functions.txt")
  end

  def metric_with_functions_converted
    [
      {
        :key       => "scale(summarize(my.metric, \"5min\"),0.2)",
        :timestamp => 1337772900,
        :value     => 19.6
      },
      {
        :key       => "scale(summarize(my.metric, \"5min\"),0.2)",
        :timestamp => 1337773200,
        :value     => 23.6
      }
    ]
  end
end
