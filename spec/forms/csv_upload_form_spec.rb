# frozen_string_literal: true

require 'rails_helper'
require 'support/file_upload_helpers'

RSpec.describe(CsvUploadForm, type: :form) do
  describe '#save' do
    context 'given a VALID CSV file' do
      it 'returns true' do
        form = described_class.new
        file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

        success = form.save(file)

        expect(success).to(be(true))
      end

      it 'saves all keywords' do
        form = described_class.new
        file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

        expect do
          form.save(file)
        end.to(change(Keyword, :count).by(7))
      end

      it 'includes the created keywords in the form object' do
        form = described_class.new
        file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

        form.save(file)

        expect(form.keywords).to(all(be_a(Keyword)))
        expect(form.keywords.map(&:content)).to(contain_exactly('ruby', 'database',
                                                                'oolong tea', 'com tam suon bi cha',
                                                                'marriage story', 'iphone store',
                                                                'ruby, ruby on rails'))
      end

      it 'enqueues a ScrapeKeywordJob for each keyword' do
        ActiveJob::Base.queue_adapter = :test
        form = described_class.new
        file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

        form.save(file)

        # It would be better if we can assert that keyword_id also matches
        expect(ScrapeKeywordJob).to(have_been_enqueued.exactly(7))
      end

      context 'given keywords contain commas' do
        it 'includes commas in the parsed result' do
          form = described_class.new
          file = FileUploadHelpers::Form.upload_file(fixture: 'keywords_contain_commas.csv')

          form.save(file)

          expect(Keyword.pluck(:content)).to(include('a keyword, contains comma'))
        end
      end
    end

    context 'given an INVALID CSV file' do
      it 'returns false' do
        form = described_class.new
        file = FileUploadHelpers::Form.upload_file(fixture: 'too_many_keywords.csv')

        success = form.save(file)

        expect(success).to(be(false))
      end

      context 'given too many keywords' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers::Form.upload_file(fixture: 'too_many_keywords.csv')

          form.save(file)

          error_message = I18n.t('activemodel.csv.errors.invalid_keyword_count')
          expect(form.errors.messages_for(:keywords)).to(include(error_message))
        end
      end

      context 'given a file with incorrect content type' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers::Form.upload_file(fixture: 'wrong_type.txt', content_type: 'text/plain')

          form.save(file)

          error_message = include(I18n.t('activemodel.csv.errors.invalid_file_type'))
          expect(form.errors.messages_for(:file)).to(include(error_message))
        end
      end

      context 'given an empty file' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers::Form.upload_file(fixture: 'blank_file.csv')

          form.save(file)

          error_message = include(I18n.t('activemodel.csv.errors.invalid_keyword_count'))
          expect(form.errors.messages_for(:keywords)).to(include(error_message))
        end
      end

      context 'given a keyword that has more than 255 characters' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers::Form.upload_file(fixture: 'too_long_keywords.csv')

          form.save(file)

          error_message = include(I18n.t('activemodel.csv.errors.invalid_keyword_length'))
          expect(form.errors.messages_for(:keywords)).to(include(error_message))
        end

        it 'adds NO keywords' do
          form = described_class.new
          file = FileUploadHelpers::Form.upload_file(fixture: 'too_long_keywords.csv')

          expect do
            form.save(file)
          end.not_to(change(Keyword, :count))
        end
      end

      context 'given some blank keywords' do
        it 'skips those keywords' do
          form = described_class.new
          file = FileUploadHelpers::Form.upload_file(fixture: '6_keywords_and_blank_keywords.csv')

          expect do
            form.save(file)
          end.to(change(Keyword, :count).by(6))
        end
      end
    end
  end
end
