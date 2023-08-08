# frozen_string_literal: true

require 'csv'

class CsvUploadForm
  include ActiveModel::Model

  attr_accessor :keywords

  validates :file, presence: true, csv_keyword_file: true

  def save(file)
    @file = file
    return false unless valid?

    ActiveRecord::Base.transaction do
      keywords.each do |keyword|
        Keyword.create(content: keyword)
      end
    end

    true
  end

  private

  attr_reader :file
end
