# frozen_string_literal: true

# Basically a bunch of fixtures. Use it, change it, whatever you want.
#
# The methods in here make some assumptions about how a family is constructed,
#   but you can change or ignore these as long as you're not breaking the rules
#   to do so.
# That is, a sourcer can edit this file, but not if it would require editing the
#   tests as well.
# And an examiner can edit this file, but not if it would require editing the
#   source code.
module Hatchery
  module Names
    class << self
      def simpsons
        [bart, homer, marge]
      end

      def simpson_parents
        [homer, marge]
      end

      def bart
        'Bart Simpson'
      end

      def homer
        'Homer Simpson'
      end

      def maggie
        'Maggie Simpson'
      end

      def marge
        'Marge Simpson'
      end

      def lisa
        'Lisa Simpson'
      end

      def jose
        'José Exemplo'
      end
    end
  end

  module People
    class << self
      def simpsons
        [bart, homer, marge]
      end

      def simpson_parents
        [homer, marge]
      end

      def bart
        Fam::Family::Person.new(name: Hatchery::Names.bart)
      end

      def homer
        Fam::Family::Person.new(name: Hatchery::Names.homer)
      end

      def marge
        Fam::Family::Person.new(name: Hatchery::Names.marge)
      end

      def jose
        Fam::Family::Person.new(name: Hatchery::Names.jose)
      end
    end
  end

  module Relationships
    class << self
      def simpson_parents
        [bart_homer, bart_marge]
      end

      def bart_homer
        Fam::Family::Relationship.new(
          child_name: Hatchery::Names.bart,
          parent_name: Hatchery::Names.homer
        )
      end

      def bart_marge
        Fam::Family::Relationship.new(
          child_name: Hatchery::Names.bart,
          parent_name: Hatchery::Names.marge
        )
      end
    end
  end

  class GreatBigFamilyHatcher
    def initialize(gen_count:)
      @gen_count = gen_count
    end

    # Consructs a dense family tree @gen_count tall, starting with one child
    #   and expanding up to their parents, grandparents, great-grandparents...
    def great_big_family
      @great_big_family ||= Fam::Family.new(people: generations.flatten).tap do |family|
        generations.first(@gen_count - 1).each_with_index do |children, gen_index|
          children.zip(generations[gen_index + 1].each_slice(2)) do |child, parents|
            parents.each do |parent|
              family.add_parent(parent: parent, child: child)
            end
          end
        end
      end
    end

    def generations
      @generations ||= (0...@gen_count).map do |gen_index|
        person_count = 2**gen_index
        (0...person_count).map do |person_index|
          name = "Gen #{gen_index} Person #{person_index}"
          Fam::Family::Person.new(name: name)
        end
      end
    end

    def root_child
      generations.first.first
    end
  end
end
