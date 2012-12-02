module ResqueLatency
  module Server

    def self.included(base)
      base.class_eval do

        get '/latency' do
          "success!"
        end

      end
    end

    Resque::Server.tabs << 'Latency'
  end
end

Resque::Server.class_eval do
  include ResqeueLatency::Server
end
