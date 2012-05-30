require "spec_helper"

describe Skyscraper::Results do
  def fetch options = {}
    options.reverse_merge! fields: {}, options: {} 
    base = Skyscraper::Base.new
    base.pages options[:path]

    options[:fields].each_pair do |key, value|
      base.field key, value
    end

    Skyscraper::Results.new(base, options[:options]).fetch
  end

  it "should fetch file content" do
    results = fetch path: path_to("skyscraper-fetch.html"), fields: { h1: "h1" }
    results[0][:h1].should == "Hello world"
  end

  it "should fetch with delay" do
    time = Time.now
    results = fetch path: [path_to("skyscraper-fetch.html")] * 2, fields: { title: "title" }, options: { delay: 1 }
    time_diff = Time.now - time
    time_diff.should > 1
  end

  it "should fetch with delay after" do
    time = Time.now
    results = fetch path: [path_to("skyscraper-fetch.html")] * 10, options: { delay: { sleep: 1, after: 7 } }
    time_diff = Time.now - time
    time_diff.should > 1
    time_diff.should < 3

    time = Time.now
    results = fetch path: [path_to("skyscraper-fetch.html")] * 10, options: { delay: { sleep: 1, after: 11 } }
    time_diff = Time.now - time
    time_diff.should < 1
  end

  it "should fetch with results limit" do
    results = fetch path: [path_to("skyscraper-fetch.html")] * 11, options: { limit: 10 }
    results.length.should == 10
  end

  it "should apply config defaults" do
    base = Skyscraper::Base.new
    base.config.limit = 2
    base.pages [path_to("skyscraper-fetch.html")] * 10

    results = Skyscraper::Results.new(base).fetch
    results.length.should == 2
  end

  it "should continue after limit reached" do
    base = Skyscraper::Base.new
    base.config.limit = 1
    base.pages [path_to("skyscraper-fetch.html"), path_to("skyscraper-fetch-2.html")]
    base.field :h1, "h1"

    results = Skyscraper::Results.new(base)
    results.fetch.length.should == 1
    results.records.length.should == 1
    results.continue.length.should == 1
    results.records.length.should == 2
    results.records[1][:h1].should == "Hello from A"
  end

  describe "callbacks" do
    it "should calls after each page callback" do
      @call_count = 0
      callback = proc do |result, page|  
        result.should be_an_instance_of(Hash)
        page.should be_an_instance_of(Skyscraper::Node)
        @call_count += 1
      end
      
      results = fetch path: [path_to("skyscraper-fetch.html")] * 10, options: { after_each: [callback] }

      @call_count.should == 10
    end

    it "should calls after all callback" do
      @call_count = 0
      callback = proc do |results|  
        results.should be_an_instance_of(Array)
        @call_count += 1
      end

      results = fetch path: [path_to("skyscraper-fetch.html")] * 10, options: { after_all: [callback] }

      @call_count.should == 1
    end

    it "should change result value for each" do
      callback = proc do |result, page|  
        result[:h1] += " with callback"
      end

      results = fetch path: [path_to("skyscraper-fetch.html")] * 10, fields: { h1: "h1" }, options: { after_each: [callback] }
      results[0][:h1].should == "Hello world with callback"
    end

    it "should change results values for all" do
      callback = proc do |results|  
        results << "test"
      end

      results = fetch path: [path_to("skyscraper-fetch.html")] * 10, fields: { h1: "h1" }, options: { after_all: [callback] }
      results.last.should == "test"
    end

    it "should doesn't requires callback arguments" do
      callback = proc do 
        "with callback"
      end

      results = fetch path: [path_to("skyscraper-fetch.html")] * 10, fields: { h1: "h1" }, options: { after_each: [callback] }
      results[0][:h1].should == "Hello world"
    end

    it "should stops when after each callback returns false" do
      counter = 0

      callback = proc do 
        if counter == 1
          counter = 0
          false
        else
          counter += 1
        end
      end

      results = fetch path: [path_to("skyscraper-fetch.html")] * 10, fields: { h1: "h1" }, options: { after_each: [callback] }
      results.length.should == 2
    end
  end

  describe "errors" do
    before(:all) do
      Skyscraper.config.noise_errors = false
    end

    it "should catch invalid url exception" do
      Skyscraper.config.skip_on_error = false
      lambda do
        fetch path: "http://google.wrong" 
      end.should raise_error Skyscraper::NoResourceException
    end

    it "should catch file not exists exception" do
      Skyscraper.config.skip_on_error = false
      lambda do
        fetch path: "/tmp/skyscraper/unknow_file" 
      end.should raise_error Skyscraper::NoResourceException
    end

    it "should skip on error" do
      Skyscraper.config.skip_on_error = true
      begin 
        fetch path: "http://google.wrong"
      rescue Skyscraper::NoResourceException
        catched = true
      end
      catched.should == nil
    end
  end
end
