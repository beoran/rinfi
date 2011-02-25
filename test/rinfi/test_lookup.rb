require 'test_helper'
require 'rinfi'
require 'rinfi/lookup'

assert { Rinfi::Lookup }
lookup = nil
 
 
class Testitem
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def key
    return @name.downcase.to_sym
  end
end  
  
assert { lookup = Rinfi::Lookup.new } 
item1  = Testitem.new('HellO')
item3  = Testitem.new('Hello Hello')
assert { item1 }
assert { lookup.store(item1) } 
assert { lookup.find("Hello") }
assert { lookup.find("Hello")  == item1 }
assert { lookup.to_key('WoRLD') == :world }
item2  = "World"
assert { lookup.store(item2, lookup.to_key(:world)) }
assert { lookup.find("WoRLD") == item2              }
assert { !(lookup.also_known_as('foo', :bar))       }
assert { lookup.also('hello', :hi, :howdy)          }
assert { lookup.find(:hi)                           }
assert { lookup.find(:howdy)                        }
assert { lookup.find(:hello)                        }
assert { !lookup.find(:hey)                         }
assert { lookup.find(:hi)  ==  lookup.find("hello") }
assert { lookup.find(:hi)  ==  item1                }
assert { lookup.store(item3)                        }
assert { lookup.also('hello', item3.name)           }









 
  

