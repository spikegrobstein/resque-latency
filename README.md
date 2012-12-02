# Resque::Latency

This is a Resque plugin for storing the number of seconds that your queues are backed up.

Monitoring and alerting based on queue size is not a reliable metric. In a large enough
queue system, it can be common for a queue to contain thousands of jobs, but abnormal for
it to take too much time for a job to be performed after being enqueued.

Store a constant tally of the number of seconds that each queue takes to process a job after
enqueuing. Also, stores the datestamp for when the metric was last updated.

## Installation

**This gem is a work in progress and has not been pushed to rubygems. In the meantime, point
your gemfile or installation script to this github repository.**

Add this line to your application's Gemfile:

    gem 'resque-latency'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-latency

## Usage

This gem automatically adds a 'timestamp' to the payload of every job. When the job gets
picked up by a Resque worker, the timestamp is read and compared to the curren timestamp,
then a key (`resque:latency:QUEUE_NAME`) is updated to reflect the number of seconds and also
includes the current datestamp, so you know when this value was last updated.

Two new methods are added to the `Resque` object:

 * `Resque.latency(queue)`
 * `Resque.latency_updated_at(queue)`

### Resque.latency

Given a queue name, this is the number of seconds that the last job performed from this queue
took to be started after being enqueued.

### Resque.latency_updated_at

Given a queue name, this will return a `Time` object of when the last job was performed from
this queue. This value is there so you know if the `latency` metric is out of date.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
