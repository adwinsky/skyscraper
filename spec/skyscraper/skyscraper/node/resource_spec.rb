describe Skyscraper::Node::Resource do
  def should_download_resource_to node, path, options = {}
    resource = Skyscraper::Node::Resource.new(node)
    resource.download(options).should == path
  end

  before(:all) do
    Skyscraper.config.download_path = "/tmp/skyscraper_test/:sequence/:file_name"
    @node = Skyscraper::fetch(path_to("skyscraper-node-resource.html")).first("a")
  end

  before(:each) do
    remove_test_directory
  end

  it "should create path if not exists when downloaded" do
    File.directory?("/tmp/skyscraper_test/1").should == false
    Skyscraper::Node::Resource.new(@node)
    File.directory?("/tmp/skyscraper_test/1").should == false
    Skyscraper::Node::Resource.new(@node).download
    File.directory?("/tmp/skyscraper_test/1").should == true
  end

  it "should not fail if path already exists" do
    Skyscraper::Node::Resource.new(@node).download path: "/tmp/skyscraper_test/some_directory/:file_name"
    File.directory?("/tmp/skyscraper_test/some_directory").should == true
    Skyscraper::Node::Resource.new(@node).download
    File.directory?("/tmp/skyscraper_test/some_directory").should == true
  end

  it "should have file name" do
    resource = Skyscraper::Node::Resource.new(@node)
    resource.download.should == "/tmp/skyscraper_test/1/skyscraper-node-resource-b.html"
  end

  it "should create path with :sequence variable" do
    download_to = "/tmp/skyscraper_test/sequences/:sequence/:file_name"
    should_download_resource_to @node, "/tmp/skyscraper_test/sequences/1/skyscraper-node-resource-b.html", path: download_to
    should_download_resource_to @node, "/tmp/skyscraper_test/sequences/2/skyscraper-node-resource-b.html", path: download_to
    should_download_resource_to @node, "/tmp/skyscraper_test/sequences/3/skyscraper-node-resource-b.html", path: download_to
  end

  it "should create custom file name if provided" do
    download_to = "/tmp/skyscraper_test/custom_name/:file_name"
    should_download_resource_to @node, "/tmp/skyscraper_test/custom_name/test.html", path: download_to, file_name: "test.html"
  end

  it "should download resource" do
    Skyscraper::Node::Resource.new(@node).download
    File.exists?("/tmp/skyscraper_test/1/skyscraper-node-resource-b.html").should == true
  end

  it "should download image" do
    image_node = Skyscraper::fetch(path_to("skyscraper-node-resource.html")).first("img")
    Skyscraper::Node::Resource.new(image_node).download
    File.exists?("/tmp/skyscraper_test/1/skyscraper-node-resource-image.png").should == true
  end
end
