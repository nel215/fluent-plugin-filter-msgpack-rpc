module Fluent
  class MsgpackRpcFilter < Filter
    Fluent::Plugin.register_filter('msgpack_rpc', self)

    def configure(conf)
      log.debug "enter configure"
      super

      require "msgpack/rpc"
    end

    def start
      log.debug "enter start"
      super

      @client = MessagePack::RPC::Client.new('localhost', 3000)
    end

    def shutdown
      log.debug "enter shutdown"
      super
    end

    def filter(tag, time, record)
      log.debug "enter filter"
      @client.call(:method, time, record)
      record
    end
  end
end
