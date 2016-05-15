require 'socket'
require 'json'

logger = File.open("#{File.dirname(__FILE__)}/runtime.log", "a")
logger.puts("my pid is #{$$}")
logger.flush
args = ARGV.select {|arg| arg.start_with? "--" }.map {|arg| arg[2..-1].split "="}.to_h
logger.puts("Starting runtime at port #{args["port"]}")
logger.flush
begin
  server = TCPServer.new(args["port"])
rescue
  logger.puts $!.inspect
  logger.flush
end
begin
  socket = TCPSocket.new('localhost', args["callback-port"])
  socket.puts({pid: $$, session_id: args["uuid"]}.to_json)
rescue
  logger.puts $!.inspect
  logger.flush
end

def escape_newlines(string)
  string.gsub("\\", "\\\\").gsub("\n", " \\n")
end

def unescape_newlines(string)
  string.gsub(" \\n", "\n").gsub("\\\\", "\\")
end

loop do
  begin
    Thread.new(server.accept) do |client|
      logger.puts("incoming connection from #{client.inspect}")
      b389483479436 = binding
      loop {
        message = client.gets
        logger.puts("processing message #{message.inspect} from #{client.inspect}")
        if message.match(/shutdown#{args["port"]}/)
          logger.puts("shutting down runtime on port #{args["port"]}")
          exit
        end
        begin
          code = unescape_newlines(message)
          value = eval(code, b389483479436)
        rescue Exception => e
          value = $!
        end
        begin
          logger.puts("returning #{value.inspect} to #{client.inspect}")
          logger.flush
          client.puts(escape_newlines(value.inspect))
        rescue Exception => e
          logger.puts e.inspect
          client.puts("")
        end
      }
      client.close
    end
  rescue
    break
  end
end

