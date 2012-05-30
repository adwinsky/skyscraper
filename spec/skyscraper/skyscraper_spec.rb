#encoding: utf-8

require "spec_helper"

class TestScraper
  include Skyscraper

  pages [path_to("skyscraper.html")] * 2
  field :h1, "h1"
end

describe Skyscraper do
  it "requires necessery libraries" do
    require("open-uri").should == false
    require("uri").should == false
    require("nokogiri").should == false
    require("active_support").should == false
  end

  it "should fetch remote page" do
    Skyscraper::fetch("http://google.com").should be_an Skyscraper::Node
  end

  it "static method fetch should works" do
    Skyscraper::fetch(path_to("skyscraper.html")).first("h1").text.should == "Hello world"
  end

  it "should support utf-8 encoding by default" do
    Skyscraper::fetch(path_to("skyscraper-encoding.html")).first(".utf-8").text.should == "ąśćżół"
  end

  it "should handle http -> https redirects" do
    Skyscraper::fetch("http://github.com").first("title").text.should =~ /GitHub/
  end

  it "should works when included" do
    TestScraper.new.fetch[0][:h1].should == "Hello world"
    TestScraper.new.fetch[1][:h1].should == "Hello world"
  end

  it "should allow to set variable for config in chaining" do
    Skyscraper.config.foo = "bar"
    Skyscraper.config.foo.should == "bar"
  end
end
