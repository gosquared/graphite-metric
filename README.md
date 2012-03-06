If you're sending data to Graphite from Ruby, GraphiteMetric will help you get
it in the right format. For now, it only supports the plaintext protocol, but
pickle should be relatively easy to add. Contributions are welcome.

At [GoSquared](http://www.gosquared.com/), we're using graphite extensively.
Some services use it directly via TCP, others via UDP (direct or via
aggregators such as statsd). When metrics are critical, we push them into our
RabbitMQ cluster. Carbon agents support AMQP natively, thus an efficient and
fault-tolerant setup is achievable with little effort.

## USAGE

What is a `GraphiteMetric::Plaintext`?

    GraphiteMetric::Plaintext.ancestors
    => [GraphiteMetric::Plaintext,
     Struct,
     Enumerable,
     Object,
     TestHelpers,
     MiniTest::Expectations,
     PP::ObjectMixin,
     Kernel,
     BasicObject]

### From values

    graphite_metric = GraphiteMetric::Plaintext.new("visitors", 2)
    => #<struct GraphiteMetric::Plaintext
     key="visitors",
     value=2,
     timestamp=1331043095>

    graphite_metric.key
    => "visitors"
    graphite_metric.value
    => 2
    graphite_metric.timestamp
    => 1331043095

    graphite_metric.to_s
    => "visitors 2 1331043095"

    "#{graphite_metric}"
    => "visitors 2 1331043095"

`GraphiteMetric::Plaintext` is the same as `GMP`. The following examples will
use the abbreviated form.

### From hash

    gmp = GMP.from_hash(
      :key       => "visitors",
      :value     => 2,
      :timestamp => Time.now.to_i
    )
    => #<struct GraphiteMetric::Plaintext
     key="visitors",
     value=2,
     timestamp=1331039853>

    "#{gmp}"
    => "visitors 2 1331039853"

### From array (of hashes)

    gmps = GMP.from_array([
      {
        :key       => "visitors",
        :value     => 1,
        :timestamp => Time.now.to_i
      },
      {
        :key   => "visitors",
        :value => 5
      }
    ]
    => [#<struct GraphiteMetric::Plaintext
      key="visitors",
      value=1,
      timestamp=1331039914>,
     #<struct GraphiteMetric::Plaintext
      key="visitors",
      value=5,
      timestamp=1331043514>]

    gmps.map(&:to_s)
    ["visitors 1 1331039914", "visitors 5 1331043514"]



## COMPATIBILITY

Tested against Ruby 1.9.2. Used in production on both 1.9.2 & 1.9.3.



## LICENSE

(The MIT license)

Copyright (c) Gerhard Lazu

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
