# frozen_string_literal: true

require 'pathname'
require 'json'

module Fam::File
  module Writer
    module Errors
      class Any < StandardError; end
      class InvalidPath < Any; end
    end

    def self.create(path:)
      raise InvalidPath, path.inspect if path.nil? || path.empty?

      JSONWriter.new(pathname: Pathname.new(path))
    end

    class JSONWriter
      def initialize(pathname:)
        @pathname = pathname
      end

      # Writes to the specified pathname.
      # Returns the JSON string that was written.
      def write(json_hash:)
        JSON.pretty_generate(json_hash).tap do |json_string|
          @pathname.write(json_string)
        end
      end
    end
  end
end
