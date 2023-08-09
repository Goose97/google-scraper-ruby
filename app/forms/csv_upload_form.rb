# frozen_string_literal: true

require 'csv'

class CsvUploadForm
  include ActiveModel::Model

  validates :file, presence: true, csv_keyword_file: true

  def save(file)
    @file = file
    return false unless valid?

    @keywords = parsed_keywords
    return false unless keywords_valid?

    ActiveRecord::Base.transaction do
      keywords.each do |keyword|
        Keyword.create(content: keyword)
      end
    end

    true
  end

  private

  attr_reader :file, :keywords

  def parsed_keywords
    CSV.read(file).filter_map do |csv_record|
      content = csv_record.join(',').strip
      content unless content.empty?
    end
  end

  def keywords_valid?
    errors.add(:keywords, I18n.t('activemodel.csv.errors.invalid_keyword_count')) unless valid_record_count?
    errors.add(:keywords, I18n.t('activemodel.csv.errors.invalid_keyword_length')) unless valid_keyword_length?
    errors.exclude?(:keywords)
  end

  def valid_record_count?
    keywords.length.between?(1, 1000)
  end

  def valid_keyword_length?
    keywords.all? { |keyword| keyword.length <= 255 }
  end
end
