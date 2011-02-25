require 'test_helper'
require 'rinfi'


class Callme
  def initialize(other, &block)
    @other = other
    @block = block
  end
  
  def call(*args)
    @other.instance_exec(*args, &@block) 
  end
end


assert { Rinfi::Action }

class Fakeworld
  def do_something_fake
    return :dis_something_fake
  end
end

world = Fakeworld.new
assert { world } 

action = Rinfi::Action.new(world, 'look') do |*words|
  assert { words         } 
  assert { self == world }
  assert { do_something_fake } 
  true  
end

assert { action }
assert { action.run('door') } 


callme = Callme.new(world) do |*words|
  assert { self == world }  
end

callme.call('Hello')

