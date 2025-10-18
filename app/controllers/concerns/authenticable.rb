module Authenticable
  def current_user
    return @current_user if @current_user
    header = request.headers["Authorization"]
    return nil if header.blank?

    token = header.start_with?("Bearer ") ? header.split(" ", 2).last : header
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) rescue ActiveRecord::RecordNotFound
  end

  protected

  def check_login
    head :forbidden unless self.current_user
  end
end
