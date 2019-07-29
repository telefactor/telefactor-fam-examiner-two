# frozen_string_literal: true

module Fam::CLI
  class CommonArgDefs
    def initialize(command)
      @command = command
    end

    def input_path
      tap do
        @command.option(
          :input_path,
          aliases: %w[-i],
          desc: 'The family tree file read from.',
          default: './family.json'
        )
      end
    end

    def output_path
      tap do
        @command.option(
          :output_path,
          aliases: %w[-o],
          desc: 'The family tree file to save changes to.',
          default: './family.json'
        )
      end
    end

    def person_name
      tap do
        @command.argument(
          :person_name,
          required: true,
          desc: "The person's full name. Must be unique."
        )
      end
    end

    def child_name
      tap do
        @command.argument(
          :child_name,
          required: true,
          desc: "The child's full name. Must already exist."
        )
      end
    end
  end
end
