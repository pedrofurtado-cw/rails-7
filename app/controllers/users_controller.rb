class UsersController < ApplicationController
  def me
    user_id = params[:user_id]

    phones = Phone.where(user_id: user_id)
    recharges = Recharge.where(user_id: user_id).order(created_at: :desc).limit(5)

    render json: {
      phones: phones,
      last_recharges: recharges
    }
  end
end
