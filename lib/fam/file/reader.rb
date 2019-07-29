# frozen_string_literal: true

require 'pathname'
require 'json'

module Fam::File
  module Reader
    module Errors
      class Any < StandardError; end
      class FileMissing < Any; end
      class ParserError < Any; end
    end

    def self.create(path:)
      return NullReader.new if path.nil? || path.empty?

      pathname = Pathname.new(path)
      return NullReader.new unless pathname.exist?

      JSONReader.new(pathname: pathname)
    end

    class NullReader
      def read
        {}
      end
    end

    class JSONReader
      def initialize(pathname:)
        @pathname = pathname
      end

      # Returns a hash with symbol keys
      def read
        raise Errors::FileMissing, @pathname unless @pathname.exist?

        JSON.parse(
          @pathname.read,
          symbolize_names: true
        )
      rescue JSON::ParserError => e
        raise Errors::ParserError, e
      end
    end
  end
end
