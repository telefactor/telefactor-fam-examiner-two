# frozen_string_literal: true

require 'spec_helpers/cli'

RSpec.describe Fam::CLI::Add::Parents, :cli do
  let(:child_name) { Hatchery::Names.bart }
  let(:parent_names) { Hatchery::Names.simpson_parents }

  before do
    expect(
      Hatchery::Names.simpsons.map do |person_name|
        exec_fam('add', 'person', person_name)
      end
    ).to(
      all(be_success),
      'Must be able to `add person` before testing `get parents`'
    )
  end

  describe 'when the child and parent names are given' do
    subject(:add_parents) do
      exec_fam('add', 'parents', child_name, *parent_names)
    end

    it_behaves_like 'a successful command' do
      let(:expected_output) { include(*parent_names) }
    end
  end

  describe 'when all names are missing' do
    subject(:add_parents) do
      exec_fam('add', 'parent')
    end

    it_behaves_like 'a failed command'
  end
end
