# frozen_string_literal: true

# users
class UsersController < ApplicationController
  def index
    User.add.find_by(1)
  end
end
