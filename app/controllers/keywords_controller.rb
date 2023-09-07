# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    pagy, keywords = pagy(KeywordsQuery.new.call)

    render(locals: {
             pagy: pagy,
             keyword_collection_presenter: KeywordCollectionPresenter.new(keywords: keywords)
           })
  end

  def show
    keyword = Keyword.find(params[:id])

    search_entries_query = KeywordSearchEntriesQuery.new(keyword_id: keyword.id)

    render(locals: {
             keyword: keyword,
             search_entries_query: search_entries_query
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

  # rubocop:disable Metrics/MethodLength
  def search
    result = ScrapeResultSearchQuery.new(
      pattern: search_params[:search],
      query_type: search_params[:query_type]
    ).call

    render(locals: {
             search_result_presenter: SearchResultPresenter.new(search_result: result),
             search_params: search_params
           })
  rescue ActiveModel::ValidationError => error
    flash[:alert] = error.model.errors.full_messages
    redirect_to(keywords_path)
  end
  # rubocop:enable Metrics/MethodLength

  private

  def create_params
    params.require(:csv_upload_form).permit(:file)
  end

  def search_params
    {
      search: params.require(:search),
      query_type: params.require(:query_type).to_sym
    }
  end
end
