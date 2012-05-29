If you're sending data to Graphite from Ruby, GraphiteMetric will help you get
it in the right format. For now, it only supports the plaintext protocol, but
pickle should be relatively easy to add. Contributions are welcome.

If you're loading data from graphite-web, you can use the raw protocol
and apply a few transformations before consuming it.

At [GoSquared] [1], we're using graphite extensively.  Some services use
it directly via TCP, others via UDP (direct or via aggregators such as
statsd). When metrics delivery is critical, we push them into our
RabbitMQ cluster. Carbon agent supports AMQP natively.

## USAGE

### GraphiteMetric::Plaintext

#### From values

```ruby
graphite_metric = GraphiteMetric::Plaintext.new("visitors", 2)

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
```

#### From hash

```ruby
gmp = GraphiteMetric::Plaintext.from_hash(
  :key       => "visitors",
  :value     => 2,
  :timestamp => Time.now.to_i
)

"#{gmp}"
=> "visitors 2 1331039853"
```

#### From array (of hashes)

```ruby
gmps = GraphiteMetric::Plaintext.from_array([
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

gmps.map(&:to_s)
["visitors 1 1331039914", "visitors 5 1331043514"]
```

### GraphiteMetric::Raw

It supports single as well as multiple raw metrics (multiple targets).
For simplicity, all examples will use single metrics:

```ruby
gmr = GraphiteMetric::Raw.new("my.metric,1336559725,1336559845,60|34.999,35.10,33.0")

gmr.metrics
=> [{:key=>"my.metric", :timestamp=>1336559725, :value=>34.999},
 {:key=>"my.metric", :timestamp=>1336559785, :value=>35.1},
 {:key=>"my.metric", :timestamp=>1336559845, :value=>33.0}]
```

#### Round all values

```ruby
gmr.round
=> #<GraphiteMetric::Raw:0x00000104054fb0
 @metrics=
  [{:key=>"my.metric", :timestamp=>1336559725, :value=>35},
   {:key=>"my.metric", :timestamp=>1336559785, :value=>35},
   {:key=>"my.metric", :timestamp=>1336559845, :value=>33}],
 @raw="my.metric,1336559725,1336559845,60|34.999,35.10,33.0\n">
```

#### Timeshift timestamps

[Graphite 0.9.9 didn't support positive timeShifts] [2]. Until 0.9.10 is
released:

```ruby
gmr.timeshift(3600)
=> #<GraphiteMetric::Raw:0x00000104054fb0
 @metrics=
  [{:key=>"my.metric", :timestamp=>1336563325, :value=>35},
   {:key=>"my.metric", :timestamp=>1336563385, :value=>35},
   {:key=>"my.metric", :timestamp=>1336563445, :value=>33}],
 @raw="my.metric,1336559725,1336559845,60|34.999,35.10,33.0\n">
```

#### Group metrics by key

```ruby
gmr.grouped_metrics
=> {"my.metric"=>
  [{:timestamp=>1336563325, :value=>35},
   {:timestamp=>1336563385, :value=>35},
   {:timestamp=>1336563445, :value=>33}]}
```

#### Reset metrics

Both timeshifting and rounding modify the internal @metrics. If you need
to reset them back to their original state:

```ruby
gmr.populate_from_raw
=> #<GraphiteMetric::Raw:0x00000101fc0ab0
 @metrics=
  [{:key=>"my.metric", :timestamp=>1336559725, :value=>34.999},
   {:key=>"my.metric", :timestamp=>1336559785, :value=>35.1},
   {:key=>"my.metric", :timestamp=>1336559845, :value=>33.0}],
 @raw="my.metric,1336559725,1336559845,60|34.999,35.10,33.0\n">
```



## Ruby 1.8

All our development and production systems run 1.9. We have no intention
of making this 1.8 compatible.



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

[1]: http://www.gosquared.com/
[2]: https://bugs.launchpad.net/graphite/+bug/903675
