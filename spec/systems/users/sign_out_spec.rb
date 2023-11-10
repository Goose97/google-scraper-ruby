# frozen_string_literal: true

require 'rails_helper'

describe 'Sign out', type: :system do
  context 'given an authenticated user' do
    it 'displays sign out button' do
      user = Fabricate(:user)

      sign_in(user)
      visit(keywords_path)

      expect(page).to(have_button(I18n.t('auth.sign_out')))
    end

    context 'when click on sign out button' do
      it 'redirects users to the sign in page' do
        user = Fabricate(:user)

        sign_in(user)
        visit(keywords_path)
        click_button(I18n.t('auth.sign_out'))

        expect(page).to(have_current_path(new_user_session_path))
      end
    end
  end
end
