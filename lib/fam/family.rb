# frozen_string_literal: true

module Fam
  # IMPLEMENT ME
  # Other than the class name, everything in here gets cleared when before
  # the code is handed off to the sourcerer.
  class Family
    module Errors
      class Any < StandardError; end
      class DuplicatePerson < Any; end
      class NoSuchPerson < Any; end
      class TooManyParents < Any; end
    end

    def initialize
      @family = {}
    end

    def add_person(person_name:)
      raise Fam::Family::Errors::DuplicatePerson, person_name.to_s if @family.include?(person_name)

      @family[person_name] = []
      person_name
    end

    def get_person(person_name:)
      raise Fam::Family::Errors::NoSuchPerson, person_name.to_s unless @family.include?(person_name)

      person_name
    end

    def add_parents(child_name:, parent_names:)
      parent_names = [parent_names] unless parent_names.is_a?(Enumerable)
      new_parents = parent_names.map do |parent_name|
        get_person(person_name: parent_name)
      end
      parents = get_parents(child_name: child_name)
      raise Fam::Family::Errors::TooManyParents, child_name.to_s if (parents + new_parents).size > 2

      @family[child_name] += new_parents
    end

    def get_parents(child_name:, generations: 0)
      child = get_person(person_name: child_name)
      parents = @family[child]
      if generations.positive?
        parents.flat_map do |parent|
          get_parents(child_name: parent, generations: generations - 1)
        end
      else
        parents
      end
    end

    def to_hash
      @family
    end
  end
end
