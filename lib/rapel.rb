require 'json'
require 'socket'
require 'securerandom'

Signal.trap("INT") do
  Rapel.shutdown
  exit
end

class Hash
  def slice(*keys)
    keys.reduce({}) {|h, k| h[k] = self[k]}
  end
end

class TCPSocket

  def accept_loop
    loop do
      message = JSON.parse(self.gets.chomp, symbolize_names: true)
      $stdout.puts("Message received: #{message} from: #{self}")
      case message[:op]
      when "eval"
        $stdout.puts("Eval message recieved: #{message[:code].inspect}")
        begin
          Rapel::REPLServer::Input.new("qer")
        rescue
          puts $!
        end
        yield Rapel::REPLServer::Input.new(message)
      else
        break
      end
    end
    close
  end

  def repl
    accept_loop do |input|
      input.read do |expression, context|
        expression.evaluate(context) do |result|
          respond_with(result)
        end
      end
    end
  end

  def respond_with(result)
    response = result.to_json
    self.puts response
    $stdout.puts "returned #{response} to #{self}"
  rescue Exception => e
    $stdout.puts e.inspect
  end
end

require "rapel/version"
require "rapel/replserver"
require "rapel/expression"
require "rapel/runtime"

module Rapel
  def self.runtimes
    @@server.runtimes
  end

  def self.escape_newlines(string)
    string.gsub("\\", "\\\\").gsub("\n", " \\n")
  end

  def self.unescape_newlines(string)
    string.gsub(" \\n", "\n").gsub("\\\\", "\\")
  end

  def self.shutdown_runtimes
    @@server.shutdown
  end

  def self.start
    @@server = REPLServer.new
    @@server.start
  end

  def self.shutdown
    @@server.shutdown
  end
end
