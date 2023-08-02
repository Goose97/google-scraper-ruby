# frozen_string_literal: true

module FileUploadHelpers
  def self.upload_file(fixture:, content_type: 'text/csv')
    path = Rails.root.join('spec', 'fixtures', 'files', fixture)
    Rack::Test::UploadedFile.new(path, content_type)
  end
end
