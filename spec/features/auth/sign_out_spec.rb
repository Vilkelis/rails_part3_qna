# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', '
  An authenticated user can sign out
' do
  given(:user) { create(:user) }

  background { visit root_path }

  scenario 'Registered user tries to sign in and then sign out' do
    click_on 'Log in'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    logout
  end

  scenario 'Not signed in user tries sign out' do
    expect(page).to have_no_content 'Log out'
  end
end
