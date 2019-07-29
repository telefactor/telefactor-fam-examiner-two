# frozen_string_literal: true

require 'fam/version'
require 'fam/cli/result'
require 'fam/file'

require 'fam/family'

module Fam
  # Includes the .success and .failure helpers which return Fam::CLI::Result objects
  #   that the CLI knows how to handle. All of the module methods should return
  #   either `success(message)` or `failure(message)`, but how they do that
  #   is up to the sourcerer.
  extend Fam::CLI::Result::Helpers
  # Includes the .read and .write helpers which will support read and writing
  #   JSON with symbol keys. These methods don't check the structure of the file,
  #   only that it is valid JSON.
  # All of the module methods should use `read(path: input_path)` to get the input family
  #   tree data, if any. Reading from a non-existant file produces an empty hash.
  # All of the "add" methods should use `write(path: output_path, json_hash: {...})`
  #   to save their output. This creates the file, or overwrites if it already exists.
  extend Fam::File::Helpers

  # These static methods are the only entrypoint that the CLI has to the application.
  #   So, as long as implementation uses the aruguments correctly and returns either
  #   `success` or `failure`, you can put whatever you want in the method bodies
  #   and in any files in the lib/fam/family directory.
  class << self
    # IMPLEMENT ME
    def add_person(
      input_path:,
      output_path:,
      person_name:
    )

      family_io(input_path: input_path, output_path: output_path) do |fam|
        fam.add_person(person_name: symbolize(person_name))
      end
      success "Added person: #{person_name}"
    rescue Fam::Family::Errors::DuplicatePerson
      failure "Person '#{person_name} already in family"
    rescue Fam::Errors::Any => e
      failure e.message
    end

    # IMPLEMENT ME
    def add_parents(
      input_path:,
      output_path:,
      child_name:,
      parent_names:
    )
      family_io(input_path: input_path, output_path: output_path) do |fam|
        fam.add_parents(child_name: symbolize(child_name),
                        parent_names: symbolize(parent_names))
      end
      success "Added #{stringify(parent_names).join(' & ')} as parents of #{child_name}"
    rescue Fam::Family::Errors::TooManyParents
      failure "Child '#{child_name}' can't have more than 2 parents!"
    rescue Fam::Family::Errors::NoSuchPerson => e
      failure "No such person '#{e.message}' in family"
    rescue Fam::Errors::Any => e
      failure e.message
    end

    # IMPLEMENT ME
    def get_person(
      input_path:,
      person_name:
    )

      family_io(input_path: input_path) do |fam|
        fam.get_person(person_name: symbolize(person_name))
      end
      success stringify(person_name)
    rescue Fam::Family::Errors::NoSuchPerson => e
      failure "No such person '#{e.message}' in family"
    rescue Fam::Errors::Any => e
      failure e.message
    end

    # IMPLEMENT ME
    def get_parents(
      input_path:,
      child_name:
    )

      parents = []
      family_io(input_path: input_path) do |fam|
        parents = fam.get_parents(child_name: symbolize(child_name))
      end
      success stringify(parents).join("\n")
    rescue Fam::Family::Errors::NoSuchPerson => e
      failure "No such person '#{e.message}' in family"
    rescue Fam::Errors::Any => e
      failure e.message
    end

    # IMPLEMENT ME
    def get_grandparents(
      input_path:,
      child_name:,
      greatness:
    )

      parents = []
      generations = greatness.to_i + 1
      family_io(input_path: input_path) do |fam|
        parents = fam.get_parents(child_name: symbolize(child_name), generations: generations.to_i)
      end
      success stringify(parents).join("\n")
    rescue Fam::Family::Errors::NoSuchPerson => e
      failure "No such person '#{e.message}' in family"
    rescue Fam::Errors::Any => e
      failure e.message
    end

    private

    def family_io(input_path:, output_path: nil)
      fam = nil
      begin
        fam = import_family(read(path: input_path))
      rescue Fam::File::Reader::Errors::FileMissing
        raise Fam::Errors::IOError, "No such file #{input_path}"
      rescue Fam::File::Reader::Errors::ParserError
        raise Fam::Errors::IOError, "#{input_path} contains invalid JSON"
      rescue Fam::Family::Errors::Any
        raise Fam::Errors::FamilyError, "#{input_path} contains invalid Family"
      end

      yield fam

      begin
        write(path: output_path, json_hash: fam.to_hash) unless output_path.nil?
      rescue Fam::Writer::Errors::Any
        raise Fam::Errors::IOError, "Unable to write to #{output_path}"
      end
    end

    def import_family(family_hash)
      fam = Family.new
      family_hash.keys.map do |person|
        fam.add_person(person_name: symbolize(person))
      end
      family_hash.keys.map do |person|
        fam.add_parents(child_name: symbolize(person), parent_names: symbolize(family_hash[person]))
      end
      fam
    end

    def symbolize(arg)
      transform(arg, &:to_sym)
    end

    def stringify(arg)
      transform(arg, &:to_s)
    end

    def transform(object, &block)
      if object.is_a?(Enumerable)
        object.map do |element|
          transform(element, &block)
        end
      else
        block.call(object)
      end
    end
  end

  module Errors
    class Any < StandardError; end
    class IOError < Any; end
    class FamilyError < Any; end
  end
end
