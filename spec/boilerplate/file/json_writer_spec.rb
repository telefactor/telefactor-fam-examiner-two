# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fam::File::Writer::JSONWriter do
  include_context 'tempdir'

  subject(:writer) do
    described_class.new(pathname: output_pathname)
  end

  let(:output_pathname) { tempdir_pathname.join('output.json') }

  describe '#write' do
    subject(:write) { writer.write(json_hash: json_hash) }

    let(:json_hash) { { people: [], relationships: [] } }

    it { is_expected.to be_a_kind_of(String) }

    it 'modifies the specified file' do
      expect { write }
        .to change { output_pathname.exist? }
        .from(false)
        .to(true)
      expect(output_pathname.read)
        .to eq JSON.pretty_generate(json_hash)
    end
  end
end
