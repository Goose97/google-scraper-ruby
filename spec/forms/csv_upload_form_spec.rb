# frozen_string_literal: true

require 'rails_helper'
require 'support/file_upload_helpers'

RSpec.describe CsvUploadForm, type: :form do
  describe '#save' do
    context 'given a VALID CSV file' do
      it 'returns true' do
        form = described_class.new
        file = FileUploadHelpers.upload_file fixture: 'valid_7_keywords.csv'

        success = form.save file

        expect(success).to be(true)
      end

      it 'saves all keywords' do
        form = described_class.new
        file = FileUploadHelpers.upload_file fixture: 'valid_7_keywords.csv'

        expect do
          form.save file
        end.to change(Keyword, :count).by(7)
      end

      it 'adds new keyword_ids to the form' do
        form = described_class.new
        file = FileUploadHelpers.upload_file fixture: 'valid_7_keywords.csv'

        form.save file

        expect(form.keyword_ids.sort).to eq(Keyword.pluck(:id).sort)
      end

      context 'given keywords contain commas' do
        it 'includes commas in the parsed result' do
          form = described_class.new
          file = FileUploadHelpers.upload_file fixture: 'keywords_contain_commas.csv'

          form.save file

          expect(Keyword.pluck(:content)).to include('a keyword, contains comma')
        end
      end
    end

    context 'given an INVALID CSV file' do
      it 'returns false' do
        form = described_class.new
        file = FileUploadHelpers.upload_file fixture: 'too_many_keywords.csv'

        success = form.save file

        expect(success).to be(false)
      end

      context 'given too many keywords' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers.upload_file fixture: 'too_many_keywords.csv'

          form.save file

          expect(form.errors.messages).to include(
            file: include(I18n.t('activemodel.csv.errors.invalid_keyword_count'))
          )
        end
      end

      context 'given a file with incorrect content type' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers.upload_file fixture: 'wrong_type.txt', content_type: 'text/plain'

          form.save file

          expect(form.errors.messages).to include(
            file: include(I18n.t('activemodel.csv.errors.invalid_file_type'))
          )
        end
      end

      context 'given an empty file' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers.upload_file fixture: 'blank_file.csv'

          form.save file

          expect(form.errors.messages).to include(
            file: include(I18n.t('activemodel.csv.errors.invalid_keyword_count'))
          )
        end
      end

      context 'given a too long keyword' do
        it 'adds an error' do
          form = described_class.new
          file = FileUploadHelpers.upload_file fixture: 'too_long_keywords.csv'

          form.save file

          expect(form.errors.messages).to include(
            file: include(I18n.t('activemodel.csv.errors.invalid_keyword_length'))
          )
        end
      end

      context 'given some blank keywords' do
        it 'skips those keywords' do
          form = described_class.new
          file = FileUploadHelpers.upload_file fixture: '6_keywords_and_blank_keywords.csv'

          expect do
            form.save file
          end.to change(Keyword, :count).by(6)
        end
      end
    end
  end
end
