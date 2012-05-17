module SkyscraperHelpers
  def path_to name
    "#{File.expand_path('../../test_files',  __FILE__)}/#{name}"
  end

  def remove_test_directory
    `rm -rf /tmp/skyscraper_test`
  end
end
