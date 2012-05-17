module Skyscraper
  class Config
    def initialize settings = {}
      @settings = settings
    end

    def method_missing name, value = nil
      if name.to_s.match /\=$/ 
        @settings.merge! name.to_s.delete("=").to_sym => value
      else
        @settings[name]
      end
    end
  end
end
