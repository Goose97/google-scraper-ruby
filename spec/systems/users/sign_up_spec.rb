# frozen_string_literal: true

require 'rails_helper'

describe 'Sign up', type: :system do
  context 'given VALID parameters' do
    it 'logs user in and redirects to the root path' do
      visit(new_user_registration_path)
      fill_in('user[email]', with: 'abc@gmail.com')
      fill_in('user[password]', with: '123456')
      fill_in('user[password_confirmation]', with: '123456')
      click_button(I18n.t('auth.sign_up'))

      expect(page).to(have_current_path(root_path))
      page.assert_selector('[data-testid="alert-notice"]', text: I18n.t('devise.registrations.signed_up'))
    end
  end
end
