require "open-uri"
require "uri"
require "nokogiri"
require "active_support/core_ext"

include ActiveSupport

module Skyscraper
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :Base
  autoload :Config
  autoload :Document
  autoload :Field
  autoload :Node
  autoload :Pages
  autoload :Path
  autoload :Results
  
  mattr_accessor :defaults
  @@defaults = {
    delay: { sleep: 0, after: 1 },
    limit: nil,
    encoding: "utf-8",
    download_path: "/tmp/skyscraper/:sequence/:file_name", 
#    reattempt_times: 1,
    noise_errors: true,
    skip_on_error: true
  }

  def self.config 
    @config ||= Skyscraper::Config.new @@defaults
  end

  def self.fetch path, encoding = Skyscraper.config.encoding
    document = Skyscraper::Document.load path, encoding
    Node::Base.new document.css("html")
  end

  def fetch
    self.class.send(:base).fetch 
  end

  module ClassMethods
    def method_missing method, *args, &block
      base.send method, *args, &block
    end

    private 

    def base
      @base ||= Skyscraper::Base.new Skyscraper.config
    end
  end
end
