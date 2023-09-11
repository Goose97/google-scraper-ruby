# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def flash_alert
    # Normalize flash[:alert] since it can be either an array of message or a single message
    # For example, devise also use flash[:alert] to display error message and pass a single message
    alert = flash[:alert]
    return alert if alert.is_a?(Array)

    [alert]
  end
end
