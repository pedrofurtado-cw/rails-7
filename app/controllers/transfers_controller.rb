class TransfersController < ApplicationController
  def create
    begin
      client = DingConnectClient.new
      product = client.get_products.dig(:body, :Items).find { |p| p.dig(:SkuCode) == transfer_params[:sku_code] }

      response = client.send_transfer(
        sku_code: transfer_params[:sku_code],
        send_value: transfer_params[:price_for_backend],
        validate_only: true,
        #account_number: transfer_params[:phone_number].to_s.gsub('+', ''),
        account_number: product.dig(:UatNumber),
        distributor_ref: 'teste1234'
      )

      if response[:success]
        phone = Phone.create!(
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
    params.require(:transfer).permit(:sku_code, :price_for_backend, :phone_number)
  end
end
