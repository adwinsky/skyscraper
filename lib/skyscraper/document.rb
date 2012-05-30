module Skyscraper
  class Document < Nokogiri::HTML::Document
    attr_accessor :path

    def self.load path, encoding = 'utf-8'
      document = Skyscraper::Document.parse open_from_path(path), nil, encoding
      document.path = Skyscraper::Path.factory(path)
      document
    end

    def self.load_post path, params = {}, encoding = 'utf-8'
      file = Net::HTTP.post_form(URI.parse(path), params).body

      document = Skyscraper::Document.parse file
      document.path = path
      document
    end

    def self.open_from_path path
      begin 
        file = open(path)
      rescue RuntimeError
        https_path = path.gsub /http:/, "https:"
        file = open(https_path) unless https_path == path
      end

      file
    end

  end
end
