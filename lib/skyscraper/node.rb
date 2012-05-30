module Skyscraper
  class Node
    alias :original_class :class

    attr_accessor :element

    def initialize element
      @element = element
    end

    def first selector
      self.find(selector).first
    end

    def find selector
      @element.css(selector).map do |element|
        Node.new(element)
      end
    end

    def children selector = nil
      if selector
        children = @element.css(selector)
      else
        children = @element.children
      end

      children.select do |element|
        element.parent == @element and element.is_a?(Nokogiri::XML::Element)
      end.map do |child|
        Node.new(child)
      end 
    end

    def parent
      if @element.parent.is_a? Nokogiri::XML::Element
        Node.new @element.parent
      end
    end

    def have_parent?
      self.parent.present? 
    end

    def parents selector = nil
      node = self
      parents = []

      while node.have_parent?
        node = node.parent
        parents << node
      end

      parents.select! do |item|
        item.element.matches? selector
      end if selector

      parents
    end

    def siblings
      self.parent.children.select do |node|
        node.element != self.element
      end
    end

    def follow 
      if self.href
        Skyscraper::fetch(self.uri)
      end
    end

    def html
      @element.children.to_html
    end

    def class
      @element.attribute("class").to_s
    end

    def download options = {}
      Resource.new(self).download(options)
    end

    def uri
      @element.document.path.full_path_for(self.href)
    end

    def method_missing name
      @element.attribute(name.to_s).to_s
    end

    def text
      @element.content.to_s.strip
    end

    def tag
      @element.name
    end

    def submit params = {}
      raise Skyscraper::LocalFormException if @element.document.path.local?
      raise Skyscraper::NotActionException if self.action.blank?

      path = @element.document.path.full_path_for(self.action)
      document  = Skyscraper::Document.load_post path, params

      Node.new(document.css("html"))
    end
  end

  class LocalFormException < Exception
  end
  class NotActionException < Exception
  end
end
