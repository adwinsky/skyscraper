module Skyscraper
  module Node
    class Resource
      def initialize node
        @node           = node
        @path           = extract_path_from_node(@node)
      end

      def download options = {}
        @name          = options[:file_name] || @path.file_name
        @new_file_path = replace_path_variables(options[:path] || Skyscraper.config.download_path)
        @temp_file     = open(@path.full_path)

        copy @temp_file.path, @new_file_path
        @new_file_path
      end

      private 

      def copy from, to 
        create_path_if_not_exists to
        `cp #{from} #{to}`
      end

      def create_path_if_not_exists path
        `mkdir -p #{path}` unless File.directory?(path)
      end

      def replace_path_variables path
        new_path = path.dup
        new_path.gsub! /:file_name/, @name
        new_path.gsub! /:sequence/, get_sequence_number_for(new_path)
        new_path
      end

      def get_sequence_number_for path
        new_path = path.split(":sequence")[0]
        if File.directory?(new_path)
          entries = Dir.entries(new_path).select { |i| i =~ /^\d+$/ } || []
          last = entries.sort.last.to_i
          last += 1
          last.to_s
        else
          "1"
        end
      end

      def extract_path_from_node node
        if href_or_src = node.href.present? ? node.href : node.src
          node.element.document.path.path_for(href_or_src)
        else
          throw Exception.new("no href no src")
        end
      end
    end
  end
end
