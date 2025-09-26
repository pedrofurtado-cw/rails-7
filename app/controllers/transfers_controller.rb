require 'securerandom'

class TransfersController < ApplicationController
  def create
    begin
      desired_sku_code = "BR_#{transfer_params[:provider_code]}_TopUp_#{transfer_params[:amount]}.00"

      client = DingConnectClient.new
      product = client.get_products.dig(:body, :Items).find { |p| p.dig(:SkuCode) == desired_sku_code }

      response = client.send_transfer(
        sku_code: desired_sku_code,
        send_value: product.dig(:Maximum, :SendValue),
        validate_only: true,
        account_number: product.dig(:UatNumber),
        distributor_ref: SecureRandom.uuid.gsub('-', '')
      )

      if response[:success]
        phone = Phone.find_or_create_by!(
          user_id: params[:user_id],
          phone: transfer_params[:phone_number].to_s.gsub('+', ''),
          provider_code: product.dig(:ProviderCode)
        )

        recharge = Recharge.create!(
          user_id: params[:user_id],
          phone_id: phone.id,
          amount: product.dig(:Maximum, :ReceiveValue)
        )

        render json: {
          success: true,
          data: response[:body],
          phone: phone,
          recharge: recharge
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

  def transfer_params
    params.require(:transfer).permit(:provider_code, :amount, :phone_number)
  end
end
