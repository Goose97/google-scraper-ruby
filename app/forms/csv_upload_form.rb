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

    entries = keywords.map { |keyword| { content: keyword } }
    @keyword_ids = Keyword.create(entries).pluck('id')
    true
  end

  private

  attr_reader :file
end
