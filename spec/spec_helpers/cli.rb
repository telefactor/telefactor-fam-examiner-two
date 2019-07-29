# frozen_string_literal: true

require 'open3'

require 'spec_helper'
require 'fam/cli'

# This shared context is used in the boilerplate specs to execute actual
#   commands use the whole CLI system. It also does File I/O, so it's slow!
#   You shouldn't need to worry about this file.
RSpec.shared_context 'CLI' do
  include_context 'tempdir'

  def exec_fam(*fam_args)
    # Crazily, this is the best way to exec.
    stdout_str, stderr_str, process_status = Open3.capture3('fam', *fam_args)
    Fam::CLI::Result.new(
      stdout_str,
      stderr_str,
      process_status.exitstatus
    )
  end

  shared_examples 'a successful command' do
    let(:expected_output) { /.*/ }

    it 'exits with a zero status code' do
      expect(subject.status).to eq(0), (subject.output + subject.error)
    end

    it 'matches the expected output' do
      expect(subject.output).to match expected_output
    end
  end

  shared_examples 'a failed command' do
    let(:expected_error) { /.*/ }

    it 'exits with a non-zero status code' do
      expect(subject.status).to (be > 0), (subject.output + subject.error)
    end

    it 'matches the expected error' do
      expect(subject.error).to match expected_error
    end
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'CLI', :cli
end
