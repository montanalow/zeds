module Zeds
  class Scene
    attr_accessor :objects_by_location
    
    def initialize width, height
      @objects_by_location = Array.new( width ){ |i| Array.new(height){ |j| Array.new } }
    end

    def max_latitude
      @objects_by_location.size - 1
    end

    def max_longitude
      @objects_by_location.first.size - 1
    end

    def add object, location
      # wrap objects locations if they overflow
      location.latitude %= @objects_by_location.size
      location.longitude %= @objects_by_location[location.latitude].size

      @objects_by_location[location.latitude][location.longitude] << object
      object.location = location
      object.scene = self
      object
    end

    def delete object
      @objects_by_location[object.location.latitude][object.location.longitude].delete object
      object.location = nil
      object.scene = nil
      object
    end

    def at location
      @objects_by_location[location.latitude][location.longitude]
    end

    def update_location object, location
      delete object
      object.location = location
      add object, location
    end

    def cycle
      @objects_by_location.each do |longitude|
        longitude.each do |objects|
          objects.each do |object|
            object.cycle
          end
        end
      end
    end
    
    def draw
      puts '+' + ('-' * @objects_by_location.size) + '+'
      @objects_by_location.each do |longitude|
        print '|'
        longitude.each do |objects|
          if objects.size > 0
            objects.first.draw
          else
            print ' '
          end
        end
        print '|' + "\n"
      end
      puts '+' + ('-' * @objects_by_location.size) + '+'

      objects_by_location.each{ |x| x.each{|y| y.each{ |z|
        if z.is_a? Zeds::Agent
          puts "#{z.representation}: energy:#{z.energy} food: #{z.backpack.size} "
        end
      }}}
    end
  end
end