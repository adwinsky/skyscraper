describe Skyscraper::Node do
  describe "when is initialized" do
    before(:each) do
      @node = Skyscraper::fetch(path_to("skyscraper-node.html")).first("div.item")
    end
    
    it "should returns html code" do
      @node.html.should include "<strong class=\"name\">Name value</strong>"
    end

    it "should returns class name" do
      @node.class.should == "item"
    end

    it "should be auto converted to string with stripped tags" do
      @node.text.should == "Name value"
    end
  end

  it "should follow links" do
    Skyscraper::fetch(path_to("skyscraper-node.html")).first("li a").follow.first("h1").text.should == "Hello from A"
  end

  it "should deep follow links" do
    Skyscraper::fetch(path_to("skyscraper-node.html")).first("li a").follow.first("a").follow.first("h1").text.should == "Hello from B"
  end

  it "should download page" do
    remove_test_directory
    Skyscraper.config.download_path = "/tmp/skyscraper_test/nodes/:file_name"
    file = Skyscraper::fetch(path_to("skyscraper-node.html")).first("li a").follow.first("a").download
    File.exists?(file).should == true
  end
  describe "traversing" do
    before(:each) do
      @node = Skyscraper::fetch(path_to("skyscraper-node-traversing.html")).first(".menu")
    end

    it "should find descendands items" do
      result = @node.find("li")
      result.length.should == 5
      result.map(&:text).should include "Item 4 1"
    end

    it "should returns children of element with selector" do
      node = Skyscraper::fetch(path_to("skyscraper-node-traversing.html")).first("#parent-3")
      node.children(".a").length.should == 4
      node.children(".b").length.should == 2
    end

    it "should returns children of element without selector" do
      result = @node.children
      result.length.should == 4
      result.map(&:to_s).should_not include "Item 4 1"
    end

    it "should returns first element" do
      @node.first("li").class.should == "item-1"
    end

    it "should returns parent of item" do
      @node.parent.class.should == "parent-2"
    end

    it "should tells if element have parent" do
      @node.have_parent?.should == true
      @node.parents("html").first.have_parent?.should == false
    end

    it "should returns parents of item" do
      @node.parents.length.should == 4
    end
    
    it "should returns parents of item matched by selector" do
      @node.parents("div").length.should == 2
    end

    it "should returns siblings of item" do
      @node.first(".item-3").siblings.length.should == 3
    end

    it "should returns node tag" do
      @node.tag.should == "ul"
    end
  end
end

