# frozen_string_literal: true

require 'hanami/cli'

module Fam
  module CLI
    class Command < Hanami::CLI::Command
      def finish(result)
        result.output.empty? || puts(result.output)
        result.error.empty? || warn(result.error)
        exit(result.status)
      end
    end
  end
end
