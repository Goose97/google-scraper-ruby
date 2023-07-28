module Google
  class SearchServiceError < StandardError
    attr_reader :original_error

    def initialize(url, error = nil)
      @original_error = error
      msg = "Failed to perform search request with URL: #{url}"
      super(msg)
    end

    def to_s = "#{super}\nOriginal error: #{@original_error}"
  end
end
