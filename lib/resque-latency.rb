require "resque-latency/version"
require 'resque-latency/server'

module Resque

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

  def latency(queue)
    redis.get("latency:#{queue}").split(':').first.to_i
  end

  def latency_updated_at(queue)
    Time.at(redis.get("latency:#{queue}").split(':').last.to_i)
  end

end
