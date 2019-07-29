# frozen_string_literal: true

require 'spec_helpers/cli'

RSpec.describe Fam::CLI::Get::Parents, :cli do
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
    expect(
      Hatchery::Names.simpson_parents.map do |parent_name|
        exec_fam('add', 'parent', child_name, parent_name)
      end
    ).to(
      all(be_success),
      'Must be able to `add parents` before testing `get parents`'
    )
  end

  describe 'when a child name is given' do
    subject(:get_parents) do
      exec_fam('get', 'parents', child_name)
    end

    it_behaves_like 'a successful command' do
      let(:expected_output) { include(*parent_names) }
    end
  end

  describe 'when the child name is missing' do
    subject(:get_parents) do
      exec_fam('get', 'parents')
    end

    it_behaves_like 'a failed command'
  end
end
