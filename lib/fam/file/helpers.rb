# frozen_string_literal: true

module Fam::File
  module Helpers
    def read(path:)
      Fam::File::Reader
        .create(path: path)
        .read
    end

    def write(path:, json_hash:)
      Fam::File::Writer
        .create(path: path)
        .write(json_hash: json_hash)
    end
  end
end
