class AuthenticateUser
  prepend SimpleCommand

  def initialize(params)
    p "PARAMS: #{params}"
    @email = params[:email]
    @password = params[:password]
    @user = nil
  end

  def call
    user
    return @user.token if @user && @user.token_expires_at > Time.now

    JsonWebToken.encode(id: @user.id) if @user
  end

  private

  attr_accessor :email, :password

  def user
    (@user = User.find_by(email: email)).authenticate(password) ? @user : errors.add(:error,"Invalid credentials.")
  rescue
    errors.add(:error,"Invalid credentials.")
  end
end
