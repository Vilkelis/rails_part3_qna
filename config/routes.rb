# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: %i[index update new create show destroy] do
    delete :delete_file, on: :member
    resources :answers, shallow: true, only: %i[create update destroy] do
      delete :delete_file, on: :member
      patch :best, on: :member
    end
  end
end
