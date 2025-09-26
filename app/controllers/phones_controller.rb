class PhonesController < ApplicationController
  before_action :set_user_phones
  before_action :set_phone, only: [:show, :update, :destroy]

  def index
    render json: @user_phones
  end

  def show
    render json: @phone
  end

  def create
    @phone = @user_phones.build(phone_params)

    if @phone.save
      render json: @phone, status: :created
    else
      render json: { errors: @phone.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @phone.update(phone_params)
      render json: @phone
    else
      render json: { errors: @phone.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @phone.destroy
    head :no_content
  end

  private

  def set_user_phones
    @user_phones = Phone.where(user_id: params[:user_id])
  end

  def set_phone
    @phone = @user_phones.find(params[:id])
  end

  def phone_params
    params.require(:phone).permit(:phone, :description, :provider_code).merge(user_id: params[:user_id])
  end
end
