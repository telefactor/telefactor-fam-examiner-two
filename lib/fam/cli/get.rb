# frozen_string_literal: true

require 'hanami/cli'

require 'fam/cli/common_arg_defs'

module Fam::CLI
  module Get
    class Person < Command
      CommonArgDefs
        .new(self)
        .input_path
        .person_name

      def call(
        input_path:,
        person_name:,
        **
      )
        finish(
          Fam.get_person(
            input_path: input_path,
            person_name: person_name
          )
        )
      end
    end

    class Parents < Command
      CommonArgDefs
        .new(self)
        .input_path
        .child_name

      desc <<~DESC
        Get the parents of a child, printing each on a seperate line.
        The parents are non-gendered, but a person only gets 2
      DESC

      def call(
        input_path:,
        child_name:,
        **
      )
        finish(
          Fam.get_parents(
            input_path: input_path,
            child_name: child_name
          )
        )
      end
    end

    class Grandparents < Command
      CommonArgDefs
        .new(self)
        .input_path
        .child_name

      option(
        :greatness,
        aliases: %w[-g],
        desc: 'The level of great-grandparent, where 0 is just grandparents.',
        default: '0'
      )

      def call(
        input_path:,
        child_name:,
        greatness:,
        **
      )
        finish(
          Fam.get_grandparents(
            input_path: input_path,
            child_name: child_name,
            greatness: greatness
          )
        )
      end
    end
  end
end
