require "rails_helper"

describe String do
  it 'response_to :new' do
    expect(String.respond_to?(:new)).to be(true)
  end
end
