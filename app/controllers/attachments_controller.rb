# frozen_string_literal: true

# Attachments controller
class AttachmentsController < ApplicationController
  before_action :load_file_and_file_owner

  def destroy
    if current_user&.author_of?(@file_owner)
      @file.purge
      if !@file.persisted?
        flash.now[:notice] = "File #{@file.filename.to_s} deleted."
      else
        flash.now[:alert] = "Can't delete file #{@file.filename.to_s}."
      end
    else
      flash.now[:alert] = 'You can delete attached files from only your own objects.'
    end
  end

  private

  def load_file_and_file_owner
    @file = ActiveStorage::Attachment.find(params[:id])
    @file_owner = @file.record
  end
end