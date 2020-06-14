# frozen_string_literal: true

class AddUserToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :user, null: false, foreign_key: true
  end
end
