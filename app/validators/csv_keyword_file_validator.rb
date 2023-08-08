# frozen_string_literal: true

require 'csv'

class CsvKeywordFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @file = value
    record.errors.add(attribute, I18n.t('activemodel.csv.errors.invalid_file_type')) unless valid_content_type?
  end

  private

  attr_reader :file

  def valid_content_type?
    file.content_type == 'text/csv'
  end
end
