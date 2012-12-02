require "resque-latency/version"

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
    # ap redis
    # ap payload

    # latency queue: resque:latency:queue_name
    key = ['latency', queue].join(':')
    latency = Time.now.utc.to_i - payload['timestamp'].to_i

    redis.set key, latency.to_s

    super
  end

  def latency(queue)
    redis.get("latency:#{queue}").to_i
  end

  module Latency
    # Your code goes here...
  end
end
