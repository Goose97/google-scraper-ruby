# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization
  include Pagy::Backend

  before_action :authenticate_user!
end
