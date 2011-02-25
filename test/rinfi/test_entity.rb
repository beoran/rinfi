require 'test_helper'
require 'rinfi'

assert { Rinfi::Entity } 
entity = nil
world  = 'world'
name   = 'entity'
assert { entity = Rinfi::Entity.new(world, name) } 
assert { entity.name == name } 
assert { entity.world == world }
assert { entity.also = 'thing', 'item' }
assert { entity.also == ['item', 'thing'] }
assert { entity.also = ['thing', 'item'] }
assert { entity.also == ['item', 'thing'] }
assert { entity.also_known_as('bob')}
assert { entity.also == ["bob", 'item', 'thing'] }
assert { entity.also_known_as('bob')}
assert { entity.also == ["bob", 'item', 'thing'] }
assert { entity.also_known_as('item')}
assert { entity.also == ["bob", 'item', 'thing']  }
assert { entity.name_match('bob')                 } 
assert { entity.name_match('item')                }
assert { entity.name_match('thing')               }
assert { entity.name_match('entity')              }
assert { !entity.name_match('foo')                }




