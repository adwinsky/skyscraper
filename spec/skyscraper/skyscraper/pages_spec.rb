describe Skyscraper::Pages do
  it "should set convert string to items array" do
    Skyscraper::Pages.new("http://google.com").items.should == ["http://google.com"]
  end

  it "should set items array from array" do
    Skyscraper::Pages.new(["http://google.com"]).items.should == ["http://google.com"]
  end

  it "should flat pages from nested arrays" do
    Skyscraper::Pages.new(["http://google.com", ["http://yahoo.com"]]).items.should == ["http://google.com", "http://yahoo.com"]
  end

  it "should set array from block" do
    Skyscraper::Pages.new do
      2.times.map { |i| "http://google.com/#{i}.html"}
    end.items.should == ["http://google.com/0.html", "http://google.com/1.html"]
  end

  it "should pass scraper instance to block" do
    Skyscraper::Pages.new do |scraper|
      scraper.fetch(path_to("skyscraper-pages.html")).first("a").href
    end.items.should == ["a.html"]
  end

  it "should works when block is passed without arguments" do
    Skyscraper::Pages.new do 
      "a.html"
    end.items.should == ["a.html"]
  end

  it "should return next item" do
    pages = Skyscraper::Pages.new(["a", "b", "c"])
    pages.next.should == "a"
    pages.next.should == "b"
    pages.next.should == "c"
  end

  it "should reset pages" do
    pages = Skyscraper::Pages.new(["a", "b", "c"])
    pages.next.should == "a"
    pages.next.should == "b"
    pages.reset
    pages.next.should == "a"
  end
end
