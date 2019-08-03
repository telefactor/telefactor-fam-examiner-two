# frozen_string_literal: true

# This is the application library code!
require 'fam'

# Here are some helpers that were handy from the start!
require 'spec_helpers/hatchery'
require 'spec_helpers/tempdir'

def file_path_name(file_name:)
  "#{__dir__}/fixtures/files/#{file_name}"
end
