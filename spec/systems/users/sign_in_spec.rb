# frozen_string_literal: true

require 'rails_helper'

describe 'Sign in', type: :system do
  context 'given VALID parameters' do
    it 'logs user in and redirects to the root path' do
      user = Fabricate(:user)

      visit(new_user_session_path)
      fill_in('user[email]', with: user.email)
      fill_in('user[password]', with: user.password)
      click_button(I18n.t('auth.sign_in'))

      expect(page).to(have_current_path(root_path))
    end
  end
end
