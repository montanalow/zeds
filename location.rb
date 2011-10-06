module Zeds

  class Location
    attr_accessor :latitude, :longitude

    def initialize latitude, longitude
      @latitude = latitude
      @longitude = longitude
    end

    def == location
      @latitude == location.latitude && @longitude == location.longitude
    end
  end

end