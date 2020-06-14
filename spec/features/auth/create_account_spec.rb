# frozen_string_literal: true

require 'rails_helper'

feature 'User can create new account', '
  An unauthenticated user can create new account
' do
  scenario 'Unauthenticated user tries to create new account' do
    visit root_path
    click_on 'Sign up'

    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
