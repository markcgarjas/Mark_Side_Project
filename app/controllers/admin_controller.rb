class AdminController < ApplicationController
  before_action :authenticate_admins_user!, except: :index
end
