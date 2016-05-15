module Rapel

  class REPLServer

    attr_reader :runtimes

    def initialize
      @runtimes = {}
      server_port = 8091
      $stdout.puts "Starting Rapel server on port #{server_port}"
      @server = TCPServer.new(server_port)
      callback_server_port = 8092
      callback_server = TCPServer.new(callback_server_port)

      session_id = SecureRandom.uuid
      runtime = Runtime.new(callback_server_port, session_id)
      @runtimes[session_id] = runtime

      async_listen_for_runtimes(callback_server)
    end


    def async_new_repl_connections
      Thread.new(@server.accept) do |conn|
        $stdout.puts("Client connected on port: #{conn.addr[1]}")
        conn.repl
      end
    end

    def async_listen_for_runtimes(callback_server)
      Thread.new do
        Thread.new(callback_server.accept) do |callback_conn|
          message = JSON.parse(callback_conn.gets, symbolize_names: true)
          runtime = @runtimes[message[:session_id]]
          runtime.start(message[:pid])
          $stdout.puts "Runtime ready at port #{runtime.port.to_s}"
          callback_conn.close
        end
      end
    end

    def start
      loop { async_new_repl_connections }
    end

    def shutdown
      @runtimes.each do |id, runtime|
        $stdout.puts runtime.inspect
        $stdout.puts ("shutdown"+runtime.port.to_s).inspect
        runtime.shutdown
      end
    end

    class Input
      def initialize(input)
        @input = input
      end
      def read
        begin
          context = Rapel.runtimes.first[1]
          expression = Rapel::Expression.new(@input.slice(:code))
          expression
        rescue Exception => e
          $stdout.puts(e.inspect)
        end
        $stdout.puts("Input read: #{expression.inspect}")
        yield expression, context
      end
    end

  end
end
