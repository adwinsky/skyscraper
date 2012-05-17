module Skyscraper
  class Results
    attr_accessor :limit, :delay, :after_each, :after_all, :records

    def initialize base, options = {}
      @delay         = extract_delay_hash(options[:delay] || base.config.delay)
      @limit         = options[:limit] || base.config.limit

      @base          = base

      @after_each    = options[:after_each] || []
      @after_all     = options[:after_all]  || []

      @records       = []
    end

    def add_after_each &block
      @after_each << block
    end

    def add_after_all &block
      @after_all << block
    end

    def fetch continue = false
      results   = []
      documents = []

      @base.pages_object.reset unless continue

      i = 0

      while i != @limit and page = @base.pages_object.next
        result = {}

        begin
          document = Skyscraper::fetch(page)

          @base.fields.each do |field|
            result[field.name] = field.find_in_document document 
          end

          call_callbacks @after_each, result, document
          results << result
          sleep @delay[:sleep] if (i+1) % @delay[:after] == 0

        rescue SocketError, Errno::ENOENT
          warning_msg = "WARNGIN: resource '#{page}' not found!"
          puts warning_msg if @base.config.noise_errors
          raise NoResourceException, warning_msg unless @base.config.skip_on_error
        end

        i += 1
      end
      
      call_callbacks @after_all, results

      @records += results
      results
    end

    def continue
      fetch true
    end

    private

    def extract_delay_hash delay_hash
      delay = {}

      if delay_hash and delay_hash.is_a? Hash
        delay = delay_hash
      elsif delay_hash
        delay[:sleep] = delay_hash
        delay[:after] = 1
      else
        delay[:sleep] = 0
        delay[:after] = 1
      end

      delay
    end

    def call_callbacks callbacks, *args
      callbacks.each do |callback|
        callback.call(*args)
      end
    end
  end

  class NoResourceException < Exception 
  end
end
