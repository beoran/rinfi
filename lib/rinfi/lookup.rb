module Rinfi
  # A Lookup is a flexible lookup table that allows 
  # one Entity to be found using several keys
  class Lookup
    def initialize
      @items = {} 
    end
    
    def store(item, key = nil)
      key         ||= item.key 
      @items[key] ||= []
      @items[key] << item
      @items[key].sort!.uniq!
      return item
    end
    
    def to_key(name)
      return name.downcase.to_sym
    end
    
    def find_all(name)
      key = to_key(name)
      aid = @items[key]
      return aid
    end
    
    def find(name)
      found = find_all(name)
      return nil unless found
      return found.first
    end 
    
    def also_known_as(name, othername)
      item = self.find(name) 
      return nil unless item      
      key = to_key(othername)
      self.store(item, key)
      item.also_known_as(key) if key.respond_to?(:also_known_as)  
      return item
    end
    
    def also(name, *othernames)
      for other in othernames do
        also_known_as(name, other) 
      end
      return self
    end
  end
end  