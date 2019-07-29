# frozen_string_literal: true

require 'spec_helpers/cli'

RSpec.describe Fam::CLI::Add::Person, :cli do
  let(:person_name) { Hatchery::Names.jose }

  describe 'when a name is given' do
    subject(:add_person) do
      exec_fam('add', 'person', person_name)
    end

    it_behaves_like 'a successful command' do
      let(:expected_output) { person_name }
    end
  end

  describe 'when no name is provided' do
    subject(:add_person) do
      exec_fam('add', 'person')
    end

    it_behaves_like 'a failed command'
  end
end
