#encoding: utf-8
require "spec_helper"

describe Skyscraper::Document do
  it "should support utf-8 encoding by default in remote pages" do
    document = Skyscraper::Document::load("http://www.sjp.pl/grzegrz%F3%B3ka")
    document.encoding.should == "utf-8"
    document.css(".lc").first.content.strip == "Grzegrzółka"
  end

  it "should have path" do
    document = Skyscraper::Document::load(path_to("skyscraper-document.html"))
    document.path.should be_an Skyscraper::Path::Base
  end

  describe "when is opening" do
    it "should handle https redirects" do
      Skyscraper::Document.open_from_path("http://github.com").should be_an_instance_of Tempfile
    end
  end

end
