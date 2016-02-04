$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))

require 'msgpack/rpc'
require 'fluent/test'
require 'fluent/plugin/filter_msgpack_rpc'

class TestHandler
  def initialize
    @called = false
  end

  def called
    @called
  end

  def test(time, record)
    @called = true
    record
  end
end

class MsgpackRpcFilterTest < Test::Unit::TestCase
  include Fluent

  def start_server
    svr = MessagePack::RPC::Server.new
    handler = TestHandler.new
    svr.listen('0.0.0.0', 3000, handler)
    Thread.start do
      svr.run
      svr.close
    end

    return svr, handler
  end

  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    port 3000
    host 127.0.0.1
    method test
  ]

  def create_driver(conf = CONFIG)
    Test::FilterTestDriver.new(MsgpackRpcFilter, 'filter.test').configure(conf)
  end

  def emit(d, msg, time)
    d.run {
      d.emit(msg, time)
    }.filtered_as_array[0][2]
  end

  def test_call
    d = create_driver
    svr, handler = start_server
    time = Time.now.to_i
    msg = {'test' => 'test'}
    res = emit(d, msg, time)
    assert_equal(handler.called, true)
    assert_equal(res, msg)
    svr.stop
  end
end
