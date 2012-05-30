require "spec_helper"

describe Skyscraper::Path do
  describe "when path is REMOTE" do
    before(:each) do
      @path = Skyscraper::Path.factory("http://google.com/index.php?q=e")
    end

    it "local? method should returns false" do
      @path.local?.should == false
    end

    it "remote? method should returns true" do
      @path.remote?.should == true
    end

    it "should returns domain" do
      @path.domain.should == "http://google.com"
    end

    it "should returns domain with no scheme" do
      @path = Skyscraper::Path.factory("google.com/index.php?q=e")
      @path.full_path.should == "google.com/index.php?q=e"
    end

    it "should returns path" do
      @path.path.should == "/index.php"
    end

    it "should returns query" do
      @path.query.should == "?q=e"
    end

    it "should returns base" do
      @path.base.should == "http://google.com/"
    end

    it "should returns full path" do
      @path.full_path.should == "http://google.com/index.php?q=e"
    end

    it "should be converted to string" do
      @path.to_s.should == @path.full_path
    end

    it "should returns full path for full different" do
      path = Skyscraper::Path.factory("http://google.com/a/index.php")
      path.full_path_for("http://yahoo.com/b.html").should == "http://yahoo.com/b.html"
    end

    it "should returns full path for relative" do
      path = Skyscraper::Path.factory("http://google.com/a/index.php")
      path.full_path_for("b.html").should == "http://google.com/a/b.html"
    end
   
    it "should returns full path for absolute" do
      path = Skyscraper::Path.factory("http://google.com/a/index.php")
      path.full_path_for("/b.html").should == "http://google.com/b.html"
    end

    it "should returns file name" do
      path = Skyscraper::Path.factory("http://google.com/a/index.php")
      path.file_name.should == "index.php"
    end
  end

  describe "when path is LOCAL" do
    before(:each) do
      @path = Skyscraper::Path.factory("/var/www/files/file.ext")
    end

    it "should returns folder" do
      @path.folder.should == "/var/www/files/"
    end

    it "local? method should returns true" do
      @path.local?.should == true
    end

    it "remote? method should returns false" do
      @path.remote?.should == false
    end

    it "should returns file name" do
      @path.file_name.should == "file.ext"
    end

    it "should returns full path" do
      @path.full_path.should == "/var/www/files/file.ext"
    end

    it "should returns base" do
      @path.base.should == "/var/www/files/"
    end

    it "should returns full path for relative" do
      path = Skyscraper::Path.factory("/var/www/public/index.html")
      path.full_path_for("../b.html").should == "/var/www/public/../b.html"
      path.full_path_for("b.html").should == "/var/www/public/b.html"
    end
   
    it "should returns full path for absolute full" do
      path = Skyscraper::Path.factory("/var/www/public/index.html")
      path.full_path_for("/var/www/test.html").should == "/var/www/test.html"
    end
  end

  it "should detect if string is remote " do
    Skyscraper::Path.remote?("http://google.com").should == true
    Skyscraper::Path.remote?("google.com").should == true
  end

  it "should detect if string is not remote " do
    Skyscraper::Path.remote?("/var/www/projects").should == false
    Skyscraper::Path.remote?("/var/www/projects/file.ext").should == false
  end

  it "should check if is absolute address" do
    Skyscraper::Path.absolute?("/some/relative/path").should == true
  end

  it "should returns nil for wrong path" do
    path = Skyscraper::Path.factory("/var/www/files/")
    path.file_name.should == nil
  end
end
