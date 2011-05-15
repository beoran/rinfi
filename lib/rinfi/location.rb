module Rinfi
  class Location < Entity
    def initialize(world, name, detail = nil)
      @exits  = Lookup.new() 
      @world  = world
      @name   = name
      @detail = detail
    end
  end
end