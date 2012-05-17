require "open-uri"

module Skyscraper
  class Pages
    attr_accessor :items

    def initialize value = nil, &block
      set value, &block
    end

    def set value = nil, &block
      @items = block ? block.call(Skyscraper) : value
      @items = @items.is_a?(Array) ? @items : [@items]
      @items.flatten!
      reset
      self
    end

    def next
      @items[@current += 1] 
    end

    def reset
      @current = -1
    end
  end
end
