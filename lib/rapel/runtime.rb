module Rapel

  class Runtime
    
    attr_reader :session_id, :port
    attr_accessor :socket

    def initialize(callback_port, session_id)
      runtime_port = 9220
      @port = runtime_port
      @session_id = session_id
      system(ruby_runtime_string(callback_port))
    end

    def ruby_runtime_string(callback_port)
      ["ruby #{File.dirname(__FILE__)}/../../bin/runtime.rb",
      "--port=#{port}", 
      "--callback-port=#{callback_port}", 
      "--uuid=#{session_id}",
      "&"].join(" ")
    end

    def shutdown
      puts "killing at port #{port}"
      socket.puts("shutdown"+port.to_s)
    rescue
      puts "killing pid #{@pid}"
      `kill -9 #{@pid}`
    end

    def start(pid)
      @pid = pid
      @ready = true
      @socket = TCPSocket.new('localhost', port)
    end

    def inspect
      "\#<Runtime @session=\"#@session_id\" @ready=#@ready>"
    end
  end

end
