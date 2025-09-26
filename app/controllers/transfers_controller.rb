class TransfersController < ApplicationController
  before_action :set_user_phone

  def create
    begin
      client = DingConnectClient.new

      response = client.send_transfer(
        sku_code: transfer_params[:sku_code],
        send_value: transfer_params[:price_for_backend],
        #account_number: @phone.phone.to_s.gsub('+', ''),
        validate_only: true,
        account_number: DingConnectClient.new.get_products.dig(:body, :Items).find { |p| p.dig(:SkuCode) == transfer_params[:sku_code] }.dig(:UatNumber),
        distributor_ref: 'teste1234'
      )

      if response[:success]
        render json: {
          success: true,
          data: response[:body],
        }, status: :ok
      else
        render json: {
          success: false,
          error: response[:body] || response[:message],
          status: response[:status]
        }, status: :unprocessable_entity
      end
    rescue => e
      render json: {
        success: false,
        error: e.message
      }, status: :internal_server_error
    end
  end

  private

  def set_user_phone
    @phone = Phone.where(user_id: params[:user_id]).find(params[:phone_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Phone not found for this user' }, status: :not_found
  end

  def transfer_params
    params.require(:transfer).permit(:sku_code, :price_for_backend)
  end
end
