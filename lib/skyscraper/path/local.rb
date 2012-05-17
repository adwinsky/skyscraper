module Skyscraper
  module Path
    class Local < Path::Base
      attr_accessor :base, :folder, :file_name, :full_path

      def initialize path
        @folder    = get_folder(path)
        @full_path = path
        @file_name = get_file_name(path)
        @base      = @folder
      end

      def full_path_for href
        Path.absolute?(href) ? href : "#{@folder}#{href}"
      end

      def to_s
        self.full_path
      end

      private

      def get_folder path
        path.match(/\/.+\//)[0]
      end
    end
  end
end

