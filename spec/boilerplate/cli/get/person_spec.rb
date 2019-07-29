# frozen_string_literal: true

require 'spec_helpers/cli'

RSpec.describe Fam::CLI::Get::Person, :cli do
  let(:person_name) { Hatchery::Names.bart }

  before do
    expect(exec_fam('add', 'person', person_name))
      .to(
        be_success,
        'Must be able to `add person` before testing `get person`'
      )
  end

  describe 'when a name is given' do
    subject(:get_person) do
      exec_fam('get', 'person', person_name)
    end

    it_behaves_like 'a successful command' do
      let(:expected_output) { person_name }
    end
  end

  describe 'when the name is missing' do
    subject(:get_person) do
      exec_fam('get', 'person')
    end

    it_behaves_like 'a failed command'
  end
end
