module Rapel

  class Expression
    def initialize(exp)
      @expression = exp
    end

    def evaluate(context)
      $stdout.puts("Evaluating #{self.inspect} within #{context.inspect}")
      result = {session_id: context.session_id}
      begin
        context.socket.puts(Rapel.escape_newlines(@expression))
        value = context.socket.gets.chomp
        result[:result] = Rapel.unescape_newlines(value)
      rescue Exception => e
        $stdout.puts e
        result[:result] = ""
        result[:error] = e.message
      end
      $stdout.puts "Received #{value.inspect} from #{context.inspect}"
    
      yield result
    end

    def inspect
      @expression.inspect
    end
  end

end
