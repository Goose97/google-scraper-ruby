# frozen_string_literal: true

require 'csv'

class CsvUploadForm
  include ActiveModel::Validations

  INVALID_KEYWORD_COUNT_ERROR = 'file must contains between 1 to 1000 keywords'
  INVALID_FILE_TYPE_ERROR = 'file must have content type of text/csv'
  INVALID_KEYWORD_LENGTH_ERROR = 'keyword must have the maximum length of 255 characters'

  attr_reader :keyword_ids

  validates :file, presence: true, valid_keyword_file: true

  def save(file)
    @file = file
    return false unless valid?

    begin
      @keyword_ids = Keyword.insert_all(parsed_keywords).pluck('id')
      true
    rescue ActiveRecord::ValueTooLong
      errors.add(:file, INVALID_KEYWORD_LENGTH_ERROR)
      false
    end
  end

  private

  attr_reader :file

  def parsed_keywords
    CSV.read(file).filter_map do |record|
      content = record.join(',')
      unless content.strip.empty?
        {
          content: content,
          status: :processing
        }
      end
    end
  end
end
