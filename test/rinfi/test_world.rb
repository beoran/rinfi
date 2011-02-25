require 'test_helper'
require 'rinfi'

assert { Rinfi::World }
world = Rinfi::World.new()
assert { world }  

act1 = world.action 'look' do |*words|
  # check if instance eval is correctly working
  assert { self == world } 
  world.say "I will look at #{words[1]}"
end

assert { act1 }
act2 = world.find_action 'look'
assert { act2 }
assert { act1 == act2 } 
assert { act2.run('look', 'door') }
assert { ! world.quit?      } 
assert { world.quit!        }
assert { world.quit?        }
