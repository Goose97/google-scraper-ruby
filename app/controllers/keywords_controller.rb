# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index; end

  def create
    form = CsvUploadForm.new

    if form.save(create_params[:file])
      flash[:success] = I18n.t('activemodel.csv.upload_success')
    else
      flash[:errors] = form.errors.full_messages
    end

    redirect_to(keywords_path)
  end

  private

  def create_params
    params.require(:csv_upload_form).permit(:file)
  end
end
