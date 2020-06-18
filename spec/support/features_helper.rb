# frozen_string_literal: true

# Helper methods for features tests
module FeaturesHelper
  def login(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  def logout
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  def go_to_new_question_form
    visit root_path
    click_on 'Create question'
  end

  def visit_question_page(question, user = nil)
    login(user) if user
    visit(question_path(question))
  end
end
