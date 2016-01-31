module Fluent
  class MsgpackRpcFilter < Filter
    Fluent::Plugin.register_filter('msgpack_rpc', self)

    config_param :port, :integer
    config_param :host, :string, :default => 'localhost'
    config_param :method, :string

    def configure(conf)
      log.debug "enter configure"
      super

      require "msgpack/rpc"
    end

    def start
      log.debug "enter start"
      super

      @client = MessagePack::RPC::Client.new(@host, @port)
    end

    def shutdown
      log.debug "enter shutdown"
      super
    end

    def filter(tag, time, record)
      log.debug "enter filter"
      result = @client.call(@method.intern, time, record)
      result
    end
  end
end
