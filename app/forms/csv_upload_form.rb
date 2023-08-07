# frozen_string_literal: true

require 'csv'

class CsvUploadForm
  include ActiveModel::Model

  attr_reader :keyword_ids
  attr_accessor :keywords

  validates :file, presence: true, csv_keyword_file: true

  def save(file)
    @file = file
    return false unless valid?

    begin
      entries = keywords.map { |keyword| { content: keyword } }
      @keyword_ids = Keyword.create(entries).pluck('id')
      true
    rescue ActiveRecord::ValueTooLong
      errors.add(:file, I18n.t('activemodel.csv.errors.invalid_keyword_length'))
      false
    end
  end

  private

  attr_reader :file
end
