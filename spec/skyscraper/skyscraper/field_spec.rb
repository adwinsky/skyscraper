describe Skyscraper::Field do
  before(:all) do
    @page = Skyscraper::fetch(path_to("skyscraper-field.html"))
  end

  it "should find field value using css selector" do
    field = Skyscraper::Field.new name: :name, selector: ".item strong.name"
    field.find_in_document @page
    field.value.should == "Name value"
  end

  it "should apply callback" do
    callback = proc { |item| item.href * 2 } 
    field = Skyscraper::Field.new name: :name, selector: "a", callback: callback
    field.find_in_document @page
    field.value.should == "a.htmla.html"
  end

  it "should read attributes from elements" do
    field = Skyscraper::Field.new name: :name, selector: "a", attribute: :href
    field.find_in_document @page
    field.value.should == "a.html"
  end

  it "should returns text code of inner element by default" do
    field = Skyscraper::Field.new name: :name, selector: ".item"
    field.find_in_document @page
    field.value.should include "Name value"
  end

  it "should returns html code of inner element" do
    field = Skyscraper::Field.new name: :name, selector: ".item", attribute: "html"
    field.find_in_document @page
    field.value.should include "<strong class=\"name\">Name value</strong>"
  end
end
