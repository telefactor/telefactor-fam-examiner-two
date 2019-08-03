# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fam do
  include_context 'tempdir'

  let(:input_pathname) { file_path_name(file_name: 'simpsons.json') }
  let(:output_pathname) { tempdir_pathname.join('family-out.json') }
  let(:initial_family_tree) { Fam::File::Reader.create(path: input_pathname).read }
  let(:results) { Fam::File::Reader.create(path: output_pathname).read }

  context '.add_person' do
    subject { Fam.add_person(input_path: input_pathname, output_path: output_pathname, person_name: person_name) }

    describe 'add new person' do
      let(:person_name) { 'Mr. Burns' }

      it 'adds Mr. Burns to family' do
        expect(subject.output).to eq "Added person: #{person_name}"
        expect(results).to eq(initial_family_tree.merge({ :"#{person_name}" => [] }))
      end
    end

    describe 'adds same person' do
      let(:person_name) { Hatchery::Names.bart }

      it 'does not add existing person' do
        expect(subject.error).to eq "Person '#{person_name} already in family"
      end
    end
  end

  context '.add_parents' do
    subject { Fam.add_parents(input_path: input_pathname, output_path: output_pathname, child_name: child_name, parent_names: parent_names) }

    describe 'add parents for child who does not exist' do
      let(:child_name) { 'Mr. Burns' }
      let(:parent_names) { [ Hatchery::Names.homer ] }

      it 'fails to find child' do
        expect(subject.error).to eq "No such person '#{child_name}' in family"
      end
    end

    describe 'add non-existent parent for child' do
      let(:child_name) { Hatchery::Names.homer }
      let(:parent_names) { [ 'Not a real person' ] }

      it 'fails to find parent' do
        expect(subject.error).to eq "No such person '#{parent_names.first}' in family"
      end
    end

    describe 'adds parent to child with 2 parents' do
      let(:child_name) { 'Rod Flanders' }
      let(:parent_names) { [ Hatchery::Names.homer ] }

      it 'fails to add 3rd parent' do
        expect(subject.error).to eq "Child '#{child_name}' can't have more than 2 parents!"
      end
    end

    describe 'adds parent to child with 1 parents' do
      let(:child_name) { Hatchery::Names.homer }
      let(:parent_names) { [ 'Mona Simpson' ] }

      it 'adds 2nd parent' do
        expect(subject.output).to eq "Added Mona Simpson as parents of #{child_name}"
        expect(results).to eq(initial_family_tree.merge({ :"Homer Simpson" => ["Grampa Simpson", "Mona Simpson"] }))
      end
    end

    describe 'adds parents to child with no parents' do
      let(:child_name) { Hatchery::Names.bart }
      let(:parent_names) { Hatchery::Names.simpson_parents }

      it 'adds both parents' do
        expect(subject.output).to eq "Added Homer Simpson & Marge Simpson as parents of #{child_name}"
        expect(results).to eq(initial_family_tree.merge({ :"Bart Simpson" => parent_names }))
      end
    end

    describe 'add child as parent of self' do
      let(:child_name) { Hatchery::Names.bart }
      let(:parent_names) { [ child_name, child_name ] }

      it 'adds self as parent' do
        expect(subject.output).to eq "Added #{child_name} & #{child_name} as parents of #{child_name}"
        expect(results).to eq(initial_family_tree.merge({ :"Bart Simpson" => parent_names }))
      end
    end
  end

  context '.get_person' do
    subject { Fam.get_person(input_path: input_pathname, person_name: person_name) }

    describe 'get existing person' do
      let(:person_name) { Hatchery::Names.bart }

      it 'gets Mr. Burns to family' do
        expect(subject.output).to eq person_name
      end
    end

    describe 'get non-existent person' do
      let(:person_name) { 'Mr. Burns' }

      it 'does not get existing person' do
        expect(subject.error).to eq "No such person '#{person_name}' in family"
      end
    end
  end

  context '.get_parents' do
    subject { Fam.get_parents(input_path: input_pathname, child_name: child_name) }

    describe 'get parents of 2 parent child' do
      let(:child_name) { 'Rod Flanders' }

      it 'gets both parents' do
        expect(subject.output).to eq "Ned Flanders\nMaude Flanders"
      end
    end

    describe 'get parents of single parent child' do
      let(:child_name) { Hatchery::Names.homer }

      it 'gets 1 parent' do
        expect(subject.output).to eq "Grampa Simpson"
      end
    end

    describe 'get parents of no parent child' do
      let(:child_name) { Hatchery::Names.jose }

      it 'gets no parents' do
        expect(subject.output).to eq ""
      end
    end

    describe 'get parents of non-existent person' do
      let(:child_name) { 'Mr. Burns' }

      it 'does not get existing child' do
        expect(subject.error).to eq "No such person '#{child_name}' in family"
      end
    end
  end

  context '.get_grandparents' do
    subject { Fam.get_grandparents(input_path: input_pathname, child_name: child_name, greatness: greatness) }

    describe 'get grandparents of 2 parent child' do
      let(:child_name) { Hatchery::Names.lisa }
      let(:greatness) { 0 }

      it 'gets both parents' do
        expect(subject.output).to eq "Grampa Simpson\nClancy Bouvier\nJacqueline Bouvier"
      end
    end

    describe 'get grandparents of single parent child' do
      let(:child_name) { Hatchery::Names.maggie }
      let(:greatness) { 0 }

      it 'gets 1 parent' do
        expect(subject.output).to eq "Grampa Simpson"
      end
    end

    describe 'get grandparents of no parent child' do
      let(:child_name) { Hatchery::Names.jose }
      let(:greatness) { 0 }

      it 'gets no parents' do
        expect(subject.output).to eq ""
      end
    end

    describe 'get grandparents of non-existent child' do
      let(:child_name) { 'Mr. Burns' }
      let(:greatness) { 0 }

      it 'does not get existing person' do
        expect(subject.error).to eq "No such person '#{child_name}' in family"
      end
    end


    describe 'get grandparents using greatness of -1' do
      let(:child_name) { Hatchery::Names.maggie }
      let(:greatness) { -1 }

      it 'gets 1 parent' do
        expect(subject.output).to eq Hatchery::Names.homer
      end
    end

    describe 'get grandparents using greatness of 1' do
      let(:child_name) { Hatchery::Names.lisa }
      let(:greatness) { 1 }

      it 'gets 3rd generation parent' do
        expect(subject.output).to eq "Orville Simpson\nYuma Hickman\nMeaux Bouvier\nGenevieve Bouvier\nAlvarine Bisque\nFerdinand Gurney"
      end
    end
  end
end
