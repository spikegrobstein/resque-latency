require "resque-latency/version"
require 'resque-latency/server'

module Resque

  # monkey-patch Job.create
  # This will include a `timestamp` key on the payload of every job that gets queued
  def Job.create(queue, klass, *args)
    Resque.validate(klass, queue)

    if Resque.inline?
      # Instantiating a Resque::Job and calling perform on it so callbacks run
      # decode(encode(args)) to ensure that args are normalized in the same manner as a non-inline job
      new(:inline, {'class' => klass, 'args' => decode(encode(args))}).perform
    else
      Resque.push(queue, 'class' => klass.to_s, 'args' => args, 'timestamp' => Time.now.utc.to_i)
    end
  end

  # monkey-patch Job.new
  # This will pull the `timestamp` field out of the payload
  # and calculate the latency of the queue and store it in a new key:
  # resque:latency:QUEUE_NAME
  # latency is stored as seconds from queueing to picking the job up
  # and the timestamp that it was last updated.
  def Job.new(queue, payload)
    # latency queue: resque:latency:queue_name
    key = ['latency', queue].join(':')
    latency = Time.now.utc.to_i - payload['timestamp'].to_i

    # store the latency of this job in seconds and the current timestamp in the key
    # timestamp is stored in seconds since epoch UTC.
    # delimited by :
    redis.set key, [ latency.to_s, Time.now.utc.to_i ].join(':')

    super
  end

  # return the latency, in seconds, of the given queue
  def latency(queue)
    l = redis.get("latency:#{queue}")

    return nil if l.nil?

    l = l.split(':').first.to_i

    (l > 0) ? l : 0
  end

  # return the Time of the last time this latency metric was updated.
  def latency_updated_at(queue)
    l = redis.get("latency:#{queue}")

    return nil if l.nil?

    Time.at(l.split(':').last.to_i)
  end

end
