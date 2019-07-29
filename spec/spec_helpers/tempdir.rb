# frozen_string_literal: true

require 'pathname'
require 'tmpdir'

# Including this context makes the test run in a temporary directory that is
#   created before each test and deleted afterwards. Note that this is quite slow,
#   so only include it if a test needs to edit files.
#
# Available let-helpers:
#   tempdir_pathname - A Pathname object wrapping the tempdir string.
#   original_dir_pathname - A Pathname object of the directory before navigating to tempdir.
#   tempdir - The string path of the created directory.
#
# Configurable let-helpers:
#   tempdir_prefix - The prefix passed to `Dir.mktmpdir`. Default: "tempdir".
RSpec.shared_context 'tempdir' do
  let(:tempdir_prefix) { 'tempdir' }

  let(:original_dir_pathname) do
    Pathname.pwd
  end

  let(:tempdir_pathname) do
    Pathname.new(tempdir)
  end

  let(:tempdir) do
    Dir.mktmpdir(tempdir_prefix)
  end

  before(:each) do
    expect(original_dir_pathname).to exist
    expect(tempdir_pathname).to exist
    Dir.chdir(tempdir_pathname)
  end

  after(:each) do
    expect(original_dir_pathname).to exist
    Dir.chdir(original_dir_pathname)

    FileUtils.remove_dir(tempdir, true)
    expect(tempdir_pathname).to_not exist
  end
end
