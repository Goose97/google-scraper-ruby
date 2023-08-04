# frozen_string_literal: true

require 'csv'

class CsvUploadForm
  include ActiveModel::Model

  attr_reader :keyword_ids

  validates :file, presence: true, csv_keyword_file: true

  def save(file)
    @file = file
    return false unless valid?

    begin
      @keyword_ids = Keyword.create(parsed_keywords).pluck('id')
      true
    rescue ActiveRecord::ValueTooLong
      errors.add(:file, I18n.t('csv.errors.invalid_keyword_length'))
      false
    end
  end

  private

  attr_reader :file

  def parsed_keywords
    CSV.read(file).filter_map do |record|
      content = record.join ','
      { content: content } unless content.strip.empty?
    end
  end
end
