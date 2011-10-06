require 'scene.rb'

module Zeds
  class Object
    attr_accessor :representation, :location, :scene

    def initialize representation = ' '
      @representation = representation
    end

    def cycle
    end
    
    def draw
      print @representation
    end
  end
end