require 'object.rb'

module Zeds
  class Food < Zeds::Object
    def initialize amount = 4
      @amount = amount
    end

    def draw
      case @amount
      when 4
        print 'O'
      when 3
        print '0'
      when 2
        print 'o'
      when 1
        print '.'
      end
    end
  end
end