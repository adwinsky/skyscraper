## Installation

**Skyscraper** installation is simple, just run:

`gem install skyscraper`

or add following entry to your gemfile:

`gem "skyscraper"`

if you want to use it in your rails project.

## Finding nodes by CSS Selectors

```ruby
>> Skyscraper::fetch("http://rubyonrails.org").first("title").text
# => "Ruby on Rails"

>> Skyscraper::fetch("http://rubyonrails.org").first(".copyright p").text
# => "\\"Rails\\", \\"Ruby on Rails\\", and the Rails logo are registered trademarks of David Heinemeier Hansson. All rights reserved."
```

You can use this thanks to **Nokogiri#css** method.

## Reading HTML attributes
```ruby
>> Skyscraper::fetch("http://rubyonrails.org").first(".announce").class
# => "announce"
>> Skyscraper::fetch("http://rubyonrails.org").first("img").height
# => "112"
>> Skyscraper::fetch("http://rubyonrails.org").first(".copyright").style
# => "margin-top: 20px"

```

> ## Notice! 
>**Skyscraper::Node::Base#class** method is overriden, to access original **class** method, please call Skyscraper::Node::Base#original_class

You can find list of all available methods in [Reading attributes Section](wiki/reading_attributes)

## Using Skyscraper as included module

Fetch content from multiple pages and store it in the active record database is a common problem. You can do this quick, using **Skyscraper** as included module.

```ruby
class Sample
  include Skyscraper

  settings limit: 10, delay: { after: 5, time: 1 }, encoding: "utf-8"

  pages ["http://google.com", "https://github.com", "http://rubyonrails.org"]
  # pages method also accepts blocks as argument, then you can use Skyscraper::fetch method inside to get list of pages from website more dynamically

  field :html, "html", :html
  field :title, "title" do |node|
    "'#{node.text}'"
  end
  field :first_link, "body" do |node|
    "'#{node.first("a").href}'"
  end
  field :first_image, "img", :download

  # field method takes following arguments: 
  # field_name => name that the record will have in the results table
  # selector => css selector of fetching element, so it can even looks like "tag #id.some_class"
  # optionally symbol with the node method or block, if nothing is provided, text method on the node is fired

  after_each do |result|
    page = Page.new 
    page.title       = result[:title]
    page.html        = result[:html]
    page.first_link  = result[:first_link]
    page.first_image_path = results[:first_image]
    page.save
  end

  after_all do 
    puts "Job done"
  end
end

Sample.new.fetch #this will run above code applying provided callbacks and returns array with results
```
You will find more details in [Including section](wiki/Including).

## Traversing

Traversing through **Skyscraper** nodes is very similar to the way **jQuery** provides.

```ruby
>> Skyscraper::fetch("https://github.com").first(".top-nav").find("li").map(&:html)
# => ["<a href="https://github.com/plans">Signup and Pricing</a>", "<a href="https://github.com/explore">Explore GitHub</a>", "<a href="https://github.com/features">Features</a>", "<a href="https://github.com/blog">Blog</a>", "<a href="https://github.com/login">Login</a>"]
```

Of course you can write the same code in the easier way:

```ruby
>> Skyscraper::fetch("https://github.com").find(".top-nav li").map(&:html)
# => ["<a href=\\"https://github.com/plans\\">Signup and Pricing</a>", "<a href=\\"https://github.com/explore\\">Explore GitHub</a>", "<a href=\\"https://github.com/features\\">Features</a>", "<a href=\\"https://github.com/blog\\">Blog</a>", "<a href=\\"https://github.com/login\\">Login</a>"]
```

or even:

```ruby
>> Skyscraper::fetch("https://github.com").find(".top-nav li a").map(&:content)
# => ["<a href=\\"https://github.com/plans\\">Signup and Pricing</a>", "<a href=\\"https://github.com/explore\\">Explore GitHub</a>", "<a href=\\"https://github.com/feature\s\">Features</a>", "<a href=\\"https://github.com/blog\\">Blog</a>", "<a href=\\"https://github.com/login\\">Login</a>"]
```

Read more about traversing in [Traversing section](wiki/traversing)

## Following 

You can quickly follow node element if it have **href** attribute:

```ruby
>> Skyscraper::fetch("https://github.com").first(".top-nav li a").follow.first("title").html
# => "Plans &amp; Pricing Â· GitHub"
```

This example visits first menu item from github.com page, and then fetch title of it.

## Downloading

When node element have **src** or **href** attribute, you can easily download it:

```ruby
>> Skyscraper::fetch("http://rubyonrails.org").first(".message img").download
# => "/tmp/skyscraper/1/rails.png"
```

You can either provide download path and new file name in arguments. Default path is also available to set in configuration.

```ruby
>> Skyscraper::fetch("http://rubyonrails.org").first(".message img").download(path: "/tmp/test/:sequence/:file_name")
# => "/tmp/test/1/rails.png"
>> Skyscraper::fetch("http://rubyonrails.org").first(".message img").download(path: "/tmp/test/:sequence/:file_name")
# => "/tmp/test/2/rails.png"
>> Skyscraper::fetch("http://rubyonrails.org").first(".message img").download(path: "/tmp/test/my_file.png")
# => "/tmp/test/my_file.png"
>> Skyscraper.config.download_path = "/tmp/test/my_path_from_config/:file_name"
# => "/tmp/test/my_path_from_config/:file_name"
>> Skyscraper::fetch("http://rubyonrails.org").first(".message img").download
# => "/tmp/test/my_path_from_config/rails.png"
```

\#download method returns path to saved file. 

## Submiting

You are also able to submit forms (currently only with POST method), by doing following:

```ruby
>> node = Skyscraper::fetch("http://www.balticplaza.eu/kontakt").first("#new_inquiry") 
# => #<Skyscraper::Node:0x9f43d88 @element=#<Nokogiri::XML::Element:0x4fa1ece name="form" ...
>> submited_page = node.submit(:"inquiry[name]" => "Example name")
# => #<Skyscraper::Node:0x9e82f84 @element=[#<Nokogiri::XML::Element:0x4f41920 name="html" ...
>> submited_page.first("#inquiry_name").value
# => "Example name"
```

## Configuration

Please visit [Configuration section](wiki/configuration) to get all details of **Skyscraper** configuration.

## Testing

Please consider that you can fetch not only remote sites but also local files. This can be very helpful when you prefer TDD coding. 

## Other topics

* [Fetching from sites with large amount of pages](wiki/fetching_large_pages) - dealing with limits, delays and other stuff

## Requirements

**Skyscraper** requires ruby in > 1.9 version. It's also depending on Nokogiri, Open-Uri, Uri and Actionpack libraries.

## What is consider to be added?

* Fetch reattempt on errors
* Testing mode - downloading only small amount of records, and showing how they would look in database
* Ruby < 1.9 versions support
* Redis, ActiveRecord cache and storage
* Ruby on Rails generators

Please don't hesitate to post me a comment about above or other functionality that might be added.

## Contributors

Here I will post list of contributors, which helps to created documentation and create bug fixes.
