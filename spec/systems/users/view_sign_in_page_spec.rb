# frozen_string_literal: true

require 'rails_helper'

describe 'View sign in page', type: :system do
  context 'given an unathenticated user' do
    it 'displays the email and password fields' do
      visit(new_user_session_path)

      expect(page).to(have_field('user[email]'))
      expect(page).to(have_field('user[password]'))
    end

    context 'given an authenticated user' do
      it 'redirects the user to the keywords#index path' do
        user = Fabricate(:user)
        sign_in(user)
        visit(new_user_session_path)

        expect(page).to(have_current_path(root_path))
      end
    end
  end
end
