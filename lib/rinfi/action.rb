module Rinfi
  class Action < Entity
    def initialize(world, name, detail = nil, &block)
      super(world, name, detail)
      @block  = block
    end
    
    # Runs the action in the context of @world. 
    def run(*args)
      @world.instance_exec(*args, &@block)
    end
  end
end