class Users::InvitePeopleController < ApplicationController
  require "rqrcode"
  before_action :invite_link
  before_action :generate_qrcode

  def index
    @member_levels = MemberLevel.all
    @invited_members = current_user.children_members
    @next_level = MemberLevel.where("required_members > ? ", current_user.children_members).first
    unless @next_level.nil?
      @member_needs = @next_level.required_members - @invited_members
    end
    @coins = MemberLevel.where("required_members > ? ", current_user.children_members).first.coins
  end

  private

  def invite_link
    if current_user
      @url = "#{request.base_url}/users/sign_up?promoter=#{current_user.email}"
    else
      @url = "#{request.base_url}/users/sign_up"
    end
  end

  def generate_qrcode

    qrcode = RQRCode::QRCode.new("#{invite_link}")

    # NOTE: showing with default options specified explicitly
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 5,
      standalone: true,
      use_path: true
    )
  end
end
