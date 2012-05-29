module Skyscraper
  class Document < Nokogiri::HTML::Document
    attr_accessor :path

    def self.load path, encoding = 'utf-8'
      document = Skyscraper::Document.parse open_from_path(path), nil, encoding
      document.path = Skyscraper::Path.factory(path)
      document
    end

    def self.open_from_path path
      file = false

      begin 
        file = open(path)
      rescue RuntimeError
        https_path = path.gsub /http:/, "https:"
        file = open(https_path) unless https_path == path
      end

      file
    end
  end
  class ResourceOpenFailedException < Exception
  end
end
