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
    keyword = Keyword.find(params['id'])

    search_entries_query = KeywordSearchEntriesQuery.new.with_keyword(keyword.id)

    render(locals: {
             keyword: keyword,
             top_ads_count: search_entries_query.top_ads_count,
             total_ads_count: search_entries_query.total_ads_count,
             non_ads_count: search_entries_query.non_ads_count,
             top_ads_urls: search_entries_query.top_ads_urls,
             non_ads_urls: search_entries_query.non_ads_urls
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
