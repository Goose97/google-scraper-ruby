# frozen_string_literal: true

module FileUploadHelpers
  def self.upload_file(fixture:, content_type: 'text/csv')
    ActionDispatch::Http::UploadedFile.new(
      filename: fixture,
      type: content_type,
      tempfile: File.new(Rails.root.join('spec', 'fixtures', 'files', fixture))
    )
  end
end
