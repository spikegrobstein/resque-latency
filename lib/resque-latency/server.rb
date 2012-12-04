require 'resque/server'

module ResqueLatency
  module Server

    def self.included(base)
      base.class_eval do

        get '/latency' do
          erb File.read(File.join(File.dirname(__FILE__), 'server/views/latency.erb'))
        end

        get '/latency.poll' do
          @polling = true
          erb File.read(File.join(File.dirname(__FILE__), 'server/views/latency.erb')), { :layout => false }
        end

        get '/latency.json' do
          content_type 'application/json'

          r = {}
          Resque.queues.each do |queue|
            r[queue] = {
              :latency => Resque.latency(queue),
              :last_updated_at => Resque.latency_updated_at(queue)
            }
          end

          r.to_json
        end

      end
    end

    Resque::Server.tabs << 'Latency'
  end
end

Resque::Server.class_eval do
  include ResqueLatency::Server
end
