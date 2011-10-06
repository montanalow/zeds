require 'scene.rb'
require 'home.rb'
require 'agent.rb'
require 'food.rb'
require 'location.rb'

scene = Zeds::Scene.new 50, 50

home = Zeds::Home.new
scene.add home, Zeds::Location.new( 30, 10 )

scene.add Zeds::Agent.new( '@', home ), Zeds::Location.new( 25, 25 )

scene.add Zeds::Food.new, Zeds::Location.new( 15, 25 )
scene.add Zeds::Food.new, Zeds::Location.new( 26, 25 )
scene.add Zeds::Food.new, Zeds::Location.new( 45, 5 )
scene.add Zeds::Food.new, Zeds::Location.new( 40, 45 )


while true
  scene.draw
  sleep 0.2
  scene.cycle
end
