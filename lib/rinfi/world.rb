module Rinfi
  class World
    def initialize
      @lookup = Lookup.new
    end
    
    # Call this to quit the game for now. 
    def quit!
      @done = true
    end
    
    # Call this to see if the game should be quit for now.
    def quit?
      @done
    end  
    
    def store(entity)
      @lookup.store(entity)
    end
    
    def find(name)
      @lookup.find(name)
    end

    def find_action(text)
      return @lookup.find(text) 
    end
    
    def action(name, detail=nil, &block)
      action = Action.new(self, name, detail, &block)
      @lookup.store(action)
    end
    
    def room(name, detail=nil, &block)
      room = Location.new(self, name, detail, &block)
      @lookup.store(room)
    end
    
    def say(*args)
      puts(*args)
      return true
    end
    
    
    
  end
end