class V1::UserController < V1Controller
  before_action :authorize
  before_action :set_user

  def show
  end

  private

  def set_user
    @user = Current.user
  end
end
