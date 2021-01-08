module ApplicationHelper
  def get_stranger_id
    1
  end

  def ategaga(float_n)
    (float_n.to_f.abs.floor(2) * 100).to_i
  end

  def set_payment_session(session)
        session[:payment_id] = session.id
  end

  def get_payment_session
    session[:payment_id] || false
  end

end
