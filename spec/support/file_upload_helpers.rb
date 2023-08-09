# frozen_string_literal: true

module FileUploadHelpers
  module Form
    def self.upload_file(fixture:, content_type: 'text/csv')
      path = Rails.root.join('spec', 'fixtures', 'files', fixture)
      Rack::Test::UploadedFile.new(path, content_type)
    end
  end

  module System
    def upload_file(fixture)
      visit(root_path)
      path = Rails.root.join('spec', 'fixtures', 'files', fixture)
      page.attach_file('csv_upload_form[file]', path, visible: false)
    end
  end
end
