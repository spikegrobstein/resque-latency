module ResqueLatency
  module Server

  end
end

Resque::Server.class_eval do
  include ResqeueLatency::Server
end
