# frozen_string_literal: true

require 'csv'

class CsvKeywordFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @file = value
    @keywords = parsed_keywords
    record.keywords = @keywords

    record.errors.add(attribute, I18n.t('activemodel.csv.errors.invalid_file_type')) unless valid_content_type?
    record.errors.add(attribute, I18n.t('activemodel.csv.errors.invalid_keyword_count')) unless valid_record_count?
    record.errors.add(attribute, I18n.t('activemodel.csv.errors.invalid_keyword_length')) unless valid_keyword_length?
  end

  private

  attr_reader :file, :keywords

  def parsed_keywords
    CSV.read(file).filter_map do |csv_record|
      content = csv_record.join(',').strip
      content unless content.empty?
    end
  end

  def valid_record_count?
    keywords.length.between?(1, 1000)
  end

  def valid_keyword_length?
    keywords.all? { |keyword| keyword.length <= 255 }
  end

  def valid_content_type?
    file.content_type == 'text/csv'
  end
end
