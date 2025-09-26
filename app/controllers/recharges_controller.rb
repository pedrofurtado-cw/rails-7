class RechargesController < ApplicationController
  def available_recharges_options
    render json: {
      options: DingConnectClient.new.get_products.dig(:body, :Items).map do |product|
        {
          provider_code: product.dig(:ProviderCode),
          sku_code: product.dig(:SkuCode),
          price_for_backend: product.dig(:Maximum, :SendValue),
          price_for_frontend: product.dig(:Maximum, :ReceiveValue)
        }
      end
    }
  end
end
