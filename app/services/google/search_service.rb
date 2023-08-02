# frozen_string_literal: true

module Google
  class SearchService
    HOST = 'www.google.com'

    # rubocop:disable Layout/LineLength
    USER_AGENT = [
      # MacOS Chrome
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
      # Window 10 Chrome
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
      # MacOS Firefox
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:77.0) Gecko/20100101 Firefox/77.0',
      # Linux Firefox
      'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1',
      # iOS Safari
      'Mozilla/5.0 (iPhone9,4; U; CPU iPhone OS 10_0_1 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14A403 Safari/602.1',
      # Android Chrome
      'Mozilla/5.0 (Linux; Android 12; SM-G973U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36'
    ].freeze
    # rubocop:enable Layout/LineLength

    private_constant :HOST, :USER_AGENT

    # rubocop:disable Metrics/MethodLength
    def search!(keyword)
      @keyword = keyword

      uri = URI::HTTPS.build host: HOST, path: '/search', query: { q: keyword }.to_query
      client = http_client uri
      response = client.get uri, {}
      unless response.success?
        raise GoogleScraperRuby::Errors::SearchServiceError.new(
          url: uri,
          error: "Response with status code #{response.status}"
        )
      end

      response.body
    rescue Faraday::ConnectionFailed, Faraday::ServerError, Faraday::ClientError => error
      raise GoogleScraperRuby::Errors::SearchServiceError.new url: uri, error: error
    end
    # rubocop:enable Metrics/MethodLength

    private

    attr_reader :keyword

    def http_client(uri)
      Faraday.new(
        url: uri,
        headers: { 'User-Agent' => USER_AGENT.sample }
      )
    end
  end
end
