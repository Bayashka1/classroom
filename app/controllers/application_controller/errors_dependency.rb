# frozen_string_literal: true
class ApplicationController
  class NotAuthorized < StandardError
  end

  rescue_from GitHub::Error,     with: :flash_and_redirect_back_with_message
  rescue_from GitHub::Forbidden, with: :flash_and_redirect_back_with_message
  rescue_from GitHub::NotFound,  with: :flash_and_redirect_back_with_message
  rescue_from NotAuthorized,     with: :flash_and_redirect_back_with_message

  private

  def flash_and_redirect_back_with_message(exception)
    flash[:error] = exception.message

    unless flash[:error].present?
      case exception
      when NotAuthorized
        flash[:error] = 'You are not authorized to perform this action'
      when GitHub::Error, GitHub::Forbidden, GitHub::NotFound
        flash[:error] = 'Uh oh, an error has occurred.'
      end
    end

    redirect_back(fallback_location: root_path)
  end
end
