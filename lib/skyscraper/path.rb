module Skyscraper
  module Path
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Local
    autoload :Remote

    class << self
      def factory path
        if Path.remote?(path)
          Path::Remote.new(path)
        else
          Path::Local.new(path)
        end
      end

      def remote? path
        path = "http://"+path unless path.match /^(http|https):\/\//
        uri  = URI.parse(path)
        uri.host ? true : false
      end

      def absolute? path
        path.starts_with? "/"
      end
    end
  end
end
