module Skyscraper
  module Path
    class Base
      def path_for path
        Path::factory(self.full_path_for(path))
      end

      private

      def get_file_name path
        path.last == "/"  ? nil : path.split("/").last
      end
    end
  end
end
