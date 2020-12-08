module HomeHelper
  def get_zenbil
    session[:current_zenbil]
  end

  def set_zenbil
    session[:current_zenbil] = SecureRandom.uuid + current_user.id.to_s
  end
end
