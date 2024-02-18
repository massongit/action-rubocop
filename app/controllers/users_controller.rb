class UsersController < ActionController::Base
  def index
    User.add.find_by(1)
  end
end
