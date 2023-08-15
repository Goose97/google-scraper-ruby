# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization
  include Pagy::Backend
end
