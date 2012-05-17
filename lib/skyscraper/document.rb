module Skyscraper
  class Document < Nokogiri::HTML::Document
    attr_accessor :path

    def self.load path, encoding = 'utf-8'
      document = Skyscraper::Document.parse open(path), nil, encoding
      document.path = Skyscraper::Path.factory(path)
      document
    end
  end
end
