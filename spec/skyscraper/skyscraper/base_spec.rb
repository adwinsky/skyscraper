require "spec_helper"

describe Skyscraper::Base do

  it "should set pages" do
    base = Skyscraper::Base.new
    base.pages "http://onet.pl"
    base.pages_object.is_a? Skyscraper::Pages
  end

  it "should have defaults for config" do
    Skyscraper.config.encoding = "utf-8"
    base = Skyscraper::Base.new
    base.config.encoding.should == "utf-8"
  end

  it "should be able to have different config for each instance" do
    base_a = Skyscraper::Base.new 
    base_a.config.bar = "foo"
    base_a.settings foo: "biz"

    base_b = Skyscraper::Base.new 
    base_b.config.bar = "biz"
    base_b.settings foo: "bar"

    base_a.config.bar.should == "foo"
    base_a.config.foo.should == "biz"
    base_b.config.bar.should == "biz"
    base_b.config.foo.should == "bar"
  end

  it "should add fields" do
    base = Skyscraper::Base.new
    base.field :name, ".selector"
    base.field :other, ".selector"
    base.fields.length.should == 2
  end

  it "should override fields with the same name" do
    base = Skyscraper::Base.new
    base.field :name, ".selector"
    base.field :name, ".selector"
    base.fields.length.should == 1 
  end

  it "should add after each callback" do
    base = Skyscraper::Base.new
    base.pages path_to("skyscraper-base.html")
    base.field :h1, "h1"
    base.after_each { |result, page| result[:h1] += "2" }
    base.fetch[0][:h1].should == "Hello world2"
  end

  it "should add after all callback" do
    base = Skyscraper::Base.new
    base.pages path_to("skyscraper-base.html")
    base.field :h1, "h1"
    base.after_all { |results| results << "2" }
    base.fetch.length.should == 2
  end

  it "should set settings" do 
    base = Skyscraper::Base.new 
    base.settings limit: 100, delay: { sleep: 2, after: 10 }
    base.config.limit.should == 100
    base.config.delay[:sleep].should == 2
    base.config.delay[:after].should == 10
  end

  it "should fetch data" do
    base = Skyscraper::Base.new
    base.pages path_to("skyscraper-base.html")
    base.field :h1, "h1"
    base.fetch[0][:h1].should == "Hello world"
  end

  it "should be able to continue fetching" do
    Skyscraper.config.limit = 10
    base = Skyscraper::Base.new
    base.pages [path_to("skyscraper-base.html")] * 12
    base.field :h1, "h1"
    base.fetch.length.should == 10
    base.continue.length.should == 2
  end
end
