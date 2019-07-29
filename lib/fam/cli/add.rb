# frozen_string_literal: true

require 'hanami/cli'

require 'fam/cli/common_arg_defs'
require 'fam/cli/result'
require 'fam/cli/command'

module Fam::CLI
  module Add
    class Person < Command
      CommonArgDefs
        .new(self)
        .input_path
        .output_path
        .person_name

      def call(
        input_path:,
        output_path:,
        person_name:,
        **
      )
        finish(
          Fam.add_person(
            input_path: input_path,
            output_path: output_path,
            person_name: person_name
          )
        )
      end
    end

    class Parents < Command
      CommonArgDefs
        .new(self)
        .input_path
        .output_path

      argument(
        :child_name,
        required: true,
        desc: "The child's full name. Must already exist."
      )
      argument(
        :parent_names,
        type: :array,
        required: true,
        desc: 'The names of one or two parents who already exist.'
      )

      def call(
        input_path:,
        output_path:,
        child_name:,
        parent_names:,
        **
      )
        finish(
          Fam.add_parents(
            input_path: input_path,
            output_path: output_path,
            child_name: child_name,
            parent_names: parent_names
          )
        )
      end
    end
  end
end
