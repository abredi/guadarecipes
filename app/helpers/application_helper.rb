module ApplicationHelper
  def get_stranger_id
    1
  end

  def ategaga(float_n)
    (float_n.to_f.abs.floor(2) * 100).to_i
  end
end
