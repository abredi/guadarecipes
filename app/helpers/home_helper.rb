module HomeHelper
  def get_zenbil
    zenbil = session[:current_zenbil]
    zenbil || set_zenbil
  end

  def set_zenbil
    session[:current_zenbil] = SecureRandom.uuid
  end
end
