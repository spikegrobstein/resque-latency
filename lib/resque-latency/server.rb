require 'resque/server'

module ResqueLatency
  module Server

    def self.included(base)
      base.class_eval do

        get '/latency' do
          erb File.read(File.join(File.dirname(__FILE__), 'server/views/latency.erb'))
        end

      end
    end

    Resque::Server.tabs << 'Latency'
  end
end

Resque::Server.class_eval do
  include ResqueLatency::Server
end
