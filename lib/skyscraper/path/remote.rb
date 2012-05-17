module Skyscraper
  module Path
    class Remote < Path::Base
      attr_accessor :uri, :base, :domain, :full_path, :path, :query, :file_name

      def initialize path
        uri = URI.parse(path)

        if uri.scheme.present?
          @domain = uri.scheme + "://" + uri.host
        else
          @domain = uri.host
        end

        @path      = uri.path
        @query     = "?" + uri.query if uri.query
        @full_path = "#{@domain}#{@path}#{@query}"
        @base      = "#{@domain}/"
        @uri       = uri
        @file_name = get_file_name(@path)
      end

      def full_path_for href
        @uri.merge(URI.parse(href)).to_s
      end

      def to_s
        self.full_path
      end
    end
  end
end
