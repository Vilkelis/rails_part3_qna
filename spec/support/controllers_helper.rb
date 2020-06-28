# frozen_string_literal: true

# Helper methods for controllers tests
module ControllersHelper
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end
