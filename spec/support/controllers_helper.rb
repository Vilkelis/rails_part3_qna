# frozen_string_literal: true

# Helper methods for controllers tests
module ControllersHelper
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def delete_question_files(question_with_files)
    files_count = question_with_files.files.count
    question_with_files.files.each do |file|
      delete :destroy, params: { id: file.id }, format: :js
    end
    question_with_files.reload
    files_count
  end

  def delete_answer_files(answer_with_files)
    files_count = answer_with_files.files.count
    answer_with_files.files.each do |file|
      delete :destroy, params: { id: file.id }, format: :js
    end
    answer_with_files.reload
    files_count
  end
end
