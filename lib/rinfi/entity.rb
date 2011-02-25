module Rinfi
  # An entity is anything that can exist in a World.
  class Entity
    attr_reader :name
    attr_reader :world
    attr_reader :also
    attr_reader :detail
    
    # Makes a new entity with the given world, name, 
    # and more detailed description. 
    def initialize(world, name, detail = nil)
      @world  = world
      @name   = name 
      @also   = [] 
      @detail = detail
    end
    
    # The comparison key of this Entity
    def key
      @name.downcase.to_sym
    end
    
    # Sets aliases to the name of this entity
    def also=(*names)
      @also = names.flatten
      @also.sort!.uniq!
    end
    
    # Adds aliases for the name of this entity
    def also_known_as(*names)
      @also += names
      @also.sort!.uniq!
      return @also
    end
    
    def name_match(text)
      try = text.downcase.to_sym
      return true if text == self.name
      return true if @also.index(text)
      return false
    end
    
    def <=>(other)
      return self.name <=> other.name
    end
    
  end
  
end
