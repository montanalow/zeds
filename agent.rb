require 'object.rb'
require 'trail.rb'

module Zeds
  class Agent < Zeds::Object
    attr_accessor :energy, :backpack
    def initialize representation, home
      super representation
      @home = home
      @backpack = []
      @energy = 400
    end
    
    def cycle
      @movements = 2
      @energy -= 1
      if @energy < 0
        raise "ZOMG Zed starved to death!"
      end
      
      if hungry? && has_food?
        eat_food and return
      end

      if has_food?
        take_food_home and return
      end
    end

    def hungry?
      @energy < 200
    end

    def eat_food
      original_size = @backpack.size
      @backpack.delete_if{ |object| object.is_a? Zeds::Food }
      @energy += (original_size - @backpack.size) * 800
    end

    def has_food?
      @backpack.each do |object|
        return true if object.is_a? Zeds::Food
      end
      false
    end

    def take_food_home
      if @location == @home.location
        set_down_food
      else
        move_toward @home.location
      end
    end

    def forage
      puts "forage"
      food = look_for Zeds::Food
      if food
        if food.location == @location
          puts "found food"
          pick_up food
        else
          puts "found food neaby"
          move_to food.location
        end
      else
        wander
      end
    end

    def look_for type_of_object, distance = 1
      @scene.at(@location).each do |object|
        if object.is_a? type_of_object
          return object
        end
      end

      latitudes = ((@location.latitude - distance)..(@location.latitude + distance)).to_a
      latitudes.delete_if{ |latitude| latitude < 0 || latitude > scene.max_latitude }
      latitudes.each do |latitude|
        longitudes = ((@location.longitude - distance)..(@location.longitude + distance)).to_a
        longitudes.delete_if{ |longitude| longitude < 0 || longitude > scene.max_longitude }
        longitudes.each do |longitude|
          @scene.at( Location.new( latitude, longitude ) ).each do |object|
            return object if object.is_a? type_of_object
          end
        end
      end

      nil
    end

    def wander
      puts "wander"
      new_lat = @location.latitude + (rand(3) - 1)  # -1, 0 , 1
      new_long = @location.longitude + (rand(3) - 1)  # -1, 0 , 1
      move_to Location.new( new_lat, new_long )
    end

    def pick_up object
      @backpack << object
      scene.delete object
    end

    def set_down object
      @backpack.delete object
      scene.add( object, @location )
    end

    def set_down_food
      @backpack.each do |object|
        set_down object if object.is_a? Zeds::Food
      end
    end

    def move_to location
      puts "move to #{location.latitude}, #{location.longitude}"
      @energy -= 2
      movements = @movements - (@location.latitude - location.latitude).abs + (@location.longitude - location.longitude).abs
      if movements < 0
        raise "Tried to move too far"
      end
      @scene.update_location( self, location )
    end

    def move_toward location
      puts "move toward"
      intermediate_location = @location.dup
      intermediate_location.latitude +=
        if intermediate_location.latitude < location.latitude
          1
        elsif intermediate_location.latitude > location.latitude
         -1
        else
          0
        end

      intermediate_location.longitude +=
        if intermediate_location.longitude < location.longitude
          1
        elsif intermediate_location.longitude > location.longitude
         -1
        else
          0
        end
        
      move_to intermediate_location
    end

    def leave_trail
      scene.add( Trail.new( self, @location ) )
    end
  end
end