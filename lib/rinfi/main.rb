require 'readline'

module Rinfi
  class Main
    def initialize(args=nil)
      @args   = args
      @world  = World.new
      @parser = Parser.new(@world)
      setup_world(@world)
    end
    
    def setup_world(world)
      world.action('quit') do |*args| 
        p args
        quit! 
        say "Bye bye!"
      end 
      world.action('room') do |*args|
        name   = args[1] 
        detail = args[2]
        if name 
          self.room(name, detail) 
          puts "Created room #{name}."
        else
          puts "Create which room?"
        end
      end
    end
    
    def readline(prompt="\n>")
      if Readline
        line = Readline.readline(prompt)
        Readline::HISTORY << line
        return line
      else
        printf(prompt)
        return Kernel.gets
      end  
    end
    
    def run_result(result)
       return result.call if result.respond_to?(:call)  
       return run_results(result.to_a) if result.respond_to?(:to_a)
       @world.say result
    end
    
    def run_results(results)
      for result in results do
        run_result(result)
      end
    end
    
    def run
      until @world.quit? do
        text    = self.readline
        results = @parser.parse(text) 
        run_results(results)
      end
    end
  
    def self.main(args) 
      main = self.new(args)
      main.run
    end
  end
end