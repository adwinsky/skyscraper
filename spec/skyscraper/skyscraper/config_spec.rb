require "spec_helper"

describe Skyscraper::Config do
  it "should set variable on initialize" do
    config = Skyscraper::Config.new foo: "bar"
    config.foo.should == "bar"
  end

 it "should set dynamic variable" do
    config = Skyscraper::Config.new foo: "bar"
    config.foo.should == "bar"
    config.bar = "foo"
    config.bar.should == "foo"
  end

  it "should override variable value" do
    config = Skyscraper::Config.new foo: "bar"
    config.foo = "bizz"
    config.foo.should == "bizz"
  end

  it "should override false value" do
    config = Skyscraper::Config.new foo: true
    config.foo = false
    config.foo.should == false
  end
end
