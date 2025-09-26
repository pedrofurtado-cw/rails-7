class RechargesController < ApplicationController
  def available_recharges_options
    pattern = /\ABR_([A-Z0-9]+)_TopUp_(\d+)\.00\z/
    render json: {
      options: DingConnectClient.new.get_products.dig(:body, :Items).select { |item| item.dig(:SkuCode).to_s.match?(pattern) }.map do |product|
        {
          provider_code: product.dig(:SkuCode).match(pattern)[1],
          amount: product.dig(:SkuCode).match(pattern)[2]
        }
      end
    }
  end
end
