module Fluent
  class MsgpackRpcFilter < Filter
    Fluent::Plugin.register_filter('msgpack_rpc', self)

    def configure(conf)
      super
    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      record
    end
  end
end
