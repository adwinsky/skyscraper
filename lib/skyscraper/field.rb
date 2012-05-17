module Skyscraper
  class Field
    attr_accessor :name, :selector, :callback, :attribute, :value

    def initialize options = {}
      @name      = options[:name]
      @selector  = options[:selector]
      @attribute = options[:attribute]
      @callback  = options[:callback]
    end

    def find_in_document document
      first_node = document.first(@selector)

      if @callback
        @value = @callback.call(first_node) 
      elsif @attribute
        @value = first_node.send @attribute
      else
        @value = first_node.text
      end
    end
  end
end
