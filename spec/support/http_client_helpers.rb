# frozen_string_literal: true

require 'rails_helper'

module HttpClientHelpers
  def self.stub_http_adapter
    adapter = Faraday::Adapter::Test::Stubs.new
    connection = Faraday.new { |b| b.adapter(:test, adapter) }
    yield(adapter, connection)
  end
end
