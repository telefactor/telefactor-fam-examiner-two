# frozen_string_literal: true

module Fam::CLI
  # This class and its Helpers module let you return a message and an exist status
  #   without having to do any I/O directly. The CLI commands understand this
  #   interface and use it to produce the final output.
  class Result
    module Helpers
      def success(message = '')
        Fam::CLI::Result.new(message, '', 0)
      end

      def failure(message = '')
        Fam::CLI::Result.new('', message, 1)
      end
    end

    def initialize(output, error, status)
      @output = output
      @error = error
      @status = status
    end

    attr_reader :output,
                :error,
                :status

    def success?
      status.zero?
    end

    def failure?
      !success?
    end
  end
end
