# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include HomeHelper

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.role == 'admin'
      products_path
    else
      orders_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username name role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username name role])
  end
end
