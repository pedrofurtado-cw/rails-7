require 'faraday'
require 'json'

class DingConnectClient
  BASE_URL = 'https://api.dingconnect.com/api/V1'

  def initialize
    @api_key = ENV['DING_CONNECT_API_KEY']
    @connection = build_connection
  end

  def send_transfer(sku_code:, send_value:, account_number:, distributor_ref:, validate_only: true)
    payload = {
      SkuCode: sku_code,
      SendValue: send_value,
      ValidateOnly: validate_only,
      AccountNumber: account_number,
      DistributorRef: distributor_ref
    }

    response = @connection.post('SendTransfer') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['api_key'] = @api_key
      req.body = payload.to_json
    end

    handle_response(response)
  end

  def get_products(country_isos: 'BR')
    response = @connection.get('GetProducts') do |req|
      req.headers['api_key'] = @api_key
      req.params['countryIsos'] = country_isos
    end

    handle_response(response)
  end

  private

  def build_connection
    Faraday.new(url: BASE_URL) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  def handle_response(response)
    {
      success: response.status.between?(200, 299),
      status: response.status,
      body: JSON.parse(response.body)&.with_indifferent_access
    }
  rescue JSON::ParserError
    {
      success: false,
      status: response.status,
      body: response.body,
      message: 'error when try parse json response'
    }
  end
end
