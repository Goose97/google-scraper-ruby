# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    pagy, keywords = pagy(KeywordsQuery.new.call)

    render(locals: {
             pagy: pagy,
             presenters: keywords
           })
  end

  def create
    form = CsvUploadForm.new

    if form.save(create_params[:file])
      flash[:notice] = I18n.t('activemodel.csv.upload_success')
    else
      flash[:alert] = form.errors.full_messages
    end

    redirect_to(keywords_path)
  end

  private

  def create_params
    params.require(:csv_upload_form).permit(:file)
  end
end
