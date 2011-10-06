require 'object.rb'

module Zeds
  class Trail < Zeds::Object
    def initialize owner
      @owner = owner
      super '*'
    end

    def cycle
    end
  end

  class ForagingTrail < Trail
  end
end

