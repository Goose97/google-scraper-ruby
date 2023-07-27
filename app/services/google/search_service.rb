# frozen_string_literal: true

module Google
  module SearchService
    SearchServiceError = GoogleScraperRuby::Errors::SearchServiceError
    HOST = 'www.google.com'
    # rubocop:disable Layout/LineLength
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36'
    # rubocop:enable Layout/LineLength

    def self.search!(keyword)
      uri = URI::HTTPS.build(host: HOST, path: '/search', query: { q: keyword }.to_query)
      conn = build_conn uri
      response = conn.get(uri, {}, { 'User-Agent' => USER_AGENT })
      if !response.success?
        raise SearchServiceError.new(uri,
                                     "Response with status code #{response.status}")
      end

      response.body
    rescue Faraday::ConnectionFailed, Faraday::ServerError, Faraday::ClientError => e
      raise SearchServiceError.new uri, e
    end

    def self.build_conn(uri)
      Faraday.new(
        url: uri,
        headers: { 'User-Agent' => USER_AGENT }
      )
    end
  end
end
