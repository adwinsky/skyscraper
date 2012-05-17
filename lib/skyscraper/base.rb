module Skyscraper
  class Base
    attr_accessor :fields, :pages_object, :config, :results

    def initialize config = nil
      @config        = (config || Skyscraper::Config.new(Skyscraper.defaults.dup))
      @fields        = []
      @fetch_options = {}
      @pages_object  = Pages.new
      @results       = Results.new self
    end
    
    def pages options = {}, &block
      @pages_object.set options, &block
    end

    def field name, selector, attribute = nil, &block
      @fields.delete @fields.detect { |f| f.name == name }
      @fields << Field.new(name: name, selector: selector, callback: block)
    end

    def after_each &block
      @results.add_after_each &block
    end

    def after_all &block
      @results.add_after_all &block
    end

    def settings options = {}
      options.each_pair do |key, val|
        @config.send "#{key}=", val
      end
    end

    def fetch
      @results.fetch
    end

    def continue
      @results.continue
    end
  end
end
