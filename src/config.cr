module Hokusai
  module OS
    class Config
      getter :directory

      def self.build
        config = new
        yield config
        config
      end

      def initialize
        @directory = Path["/os"].join("hokusai-os").to_s
      end

      def set_directory(dir : String)
        @directory = dir

        self
      end
    end
  end
end