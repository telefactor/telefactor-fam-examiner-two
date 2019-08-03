# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fam::Family do
  let(:family) { described_class.new }

  before do
    family.add_person(person_name: 'Bobby')
    family.add_person(person_name: 'Hank')
    family.add_person(person_name: 'Peggy')
    family.add_person(person_name: 'Bill')
  end

  context '.add_parents' do
    subject { family.add_parents(child_name: child_name, parent_names: parent_names) }

    describe 'no inputs' do
      let(:child_name) { }
      let(:parent_names) { }
      it 'errors with NoSuchPerson' do
        expect { subject }.to raise_error(::Fam::Family::Errors::NoSuchPerson)
      end
    end

    describe 'add child with too many parents' do
      let(:child_name) { 'Bobby' }
      let(:parent_names) { ['Hank', 'Peggy', 'Bill'] }

      it 'errors with TooManyParents' do
        expect { subject }.to raise_error(::Fam::Family::Errors::TooManyParents)
      end
    end

    describe 'add child with 2 parents' do
      let(:child_name) { 'Bobby' }
      let(:parent_names) { ['Hank', 'Peggy'] }

      it 'adds child with 2 parents' do
        subject
        expect(family.to_hash).to eq(
          {
            'Bill' => [],
            'Bobby' => ['Hank', 'Peggy'],
            'Hank' => [],
            'Peggy' => [],
          }
        )
      end
    end

    describe 'add child with 1 parents' do
      let(:child_name) { 'Bobby' }
      let(:parent_names) { ['Hank'] }

      it 'adds child with 1 parent' do
        subject
        expect(family.to_hash).to eq(
          {
            'Bill' => [],
            'Bobby' => ['Hank'],
            'Hank' => [],
            'Peggy' => [],
          }
        )
      end
    end

    describe 'add child with no parents' do
      let(:child_name) { 'Bobby' }
      let(:parent_names) { [] }

      it 'does not add parent' do
        subject
        expect(family.to_hash).to eq(
          {
            'Bill' => [],
            'Bobby' => [],
            'Hank' => [],
            'Peggy' => [],
          }
        )
      end
    end

    describe 'add child with 1 parent and then add 2nd parent' do
      subject do
        family.add_parents(child_name: child_name, parent_names: first_parent_name)
        family.add_parents(child_name: child_name, parent_names: second_parent_name)
      end

      let(:child_name) { 'Bobby' }
      let(:first_parent_name) { ['Hank'] }
      let(:second_parent_name) { ['Peggy'] }

      it 'adds child with 2 parents' do
        subject
        expect(family.to_hash).to eq(
          {
            'Bill' => [],
            'Bobby' => ['Hank', 'Peggy'],
            'Hank' => [],
            'Peggy' => [],
          }
        )
      end
    end
  end

  context '.get_parents' do
    subject { family.get_parents(child_name: child_name, generations: generations) }

    describe 'no inputs' do
      let(:child_name) { }
      let(:generations) { }

      it 'errors with NoSuchPerson' do
        expect { subject }.to raise_error(::Fam::Family::Errors::NoSuchPerson)
      end
    end

    describe 'get parents of child with 2 parents' do
      let(:child_name) { 'Bobby' }
      let(:generations) { 0 }

      before do
        family.add_parents(child_name: 'Bobby', parent_names: ['Hank', 'Peggy'])
      end

      it 'gets 2 parents' do
        expect(subject).to eq(['Hank', 'Peggy'])
      end
    end

    describe 'get parents of child with 1 parents' do
      let(:child_name) { 'Bobby' }
      let(:generations) { 0 }

      before do
        family.add_parents(child_name: 'Bobby', parent_names: ['Hank'])
      end

      it 'gets 1 parent' do
        expect(subject).to eq(['Hank'])
      end
    end

    describe 'get parents of child with no parents' do
      let(:child_name) { 'Bobby' }
      let(:generations) { 0 }

      before do
        family.add_parents(child_name: 'Bobby', parent_names: [])
      end

      it 'gets no parent' do
        expect(subject).to eq([])
      end
    end

    describe 'get 2st generation parents of child with 2 parents' do
      let(:child_name) { 'Bobby' }
      let(:generations) { 1 }

      before do
        family.add_person(person_name: 'Hank\'s dad')
        family.add_person(person_name: 'Peggy\'s dad')
        family.add_person(person_name: 'Hank\'s mom')
        family.add_person(person_name: 'Peggy\'s mom')
        family.add_parents(child_name: 'Hank', parent_names: ['Hank\'s dad', 'Hank\'s mom'])
        family.add_parents(child_name: 'Peggy', parent_names: ['Peggy\'s dad', 'Peggy\'s mom'])
        family.add_parents(child_name: 'Bobby', parent_names: ['Hank', 'Peggy'])
      end

      it 'gets 2nd generation of parents' do
        expect(subject).to eq(["Hank's dad", "Hank's mom", "Peggy's dad", "Peggy's mom"])
      end
    end
  end

  context '.add_person' do
    subject { family.add_person(person_name: person_name) }

    describe 'no inputs' do
      let(:person_name) { }

      it 'adds nil' do
        expect(subject).to eq(nil)
        expect(family.to_hash).to eq(
          {
            'Bill' => [],
            'Bobby' => [],
            'Hank' => [],
            'Peggy' => [],
            nil => [],
          }
        )
      end
    end

    describe 'add existing person' do
      let(:person_name) { 'Bobby' }

      it 'errors with DuplicatePerson' do
        expect { subject }.to raise_error(::Fam::Family::Errors::DuplicatePerson)
      end
    end

    describe 'add new person' do
      let(:person_name) { 'Luanne' }

      it 'adds Luanne' do
        expect(subject).to eq(person_name)
        expect(family.to_hash).to eq(
          {
            'Bill' => [],
            'Bobby' => [],
            'Hank' => [],
            'Luanne' => [],
            'Peggy' => [],
          }
        )
      end
    end
  end

  context '.get_person' do
    subject { family.get_person(person_name: person_name) }

    describe 'no inputs' do
      let(:person_name) { }

      it 'errors with NoSuchPerson' do
        expect { subject }.to raise_error(::Fam::Family::Errors::NoSuchPerson)
      end
    end

    describe 'get existing person' do
      let(:person_name) { 'Bobby' }

      it 'returns Bobby' do
        expect(subject).to eq(person_name)
      end
    end

    describe 'get person no in family' do
      let(:person_name) { 'Sarah' }

      it 'errors with NoSuchPerson' do
        expect { subject }.to raise_error(::Fam::Family::Errors::NoSuchPerson)
      end
    end
  end

  context '.to_hash' do
    subject { family.to_hash }

    it 'displays family as hash' do
      expect(subject).to eq(
        {
          'Bill' => [],
          'Bobby' => [],
          'Hank' => [],
          'Peggy' => [],
        }
      )
    end
  end
end
