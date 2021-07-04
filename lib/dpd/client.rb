require 'savon'

module Dpd

  class Client

    def initialize(options = {})
      defaults = {
        geo_endpoint: ENV['DPD_ENDPOINT'],
        calc_endpoint: ENV['DPD_CALC_ENDPOINT'],
        client_number: ENV['DPD_CLIENT_NUMBER'],
        client_key: ENV['DPD_CLIENT_KEY']
      }
      @options = defaults.merge(options)
    end

    def endpoint(type)
      case type
      when :geo
        return @options[:geo_endpoint]
      when :calc
        return @options[:calc_endpoint]
      else
        raise 'Unknown endpoint type'    
      end
    end

    def call(command, data = {}, type = :geo)
      client = Savon.client(wsdl: endpoint(type), raise_errors: true)
      message = {
        request: {
          auth: request_auth
        }
      }
      message[:request].merge! data
      response = client.call(command, message: message)
      response
    end

    def call_simple(command)
      client = Savon.client(wsdl: endpoint(:geo), raise_errors: true)
      message = {
        auth: request_auth
      }
      response = client.call(command, message: message)
      response
    end

    def request_auth
      {clientNumber: @options[:client_number], clientKey: @options[:client_key]}
    end

    def get_localities
      response = call(:get_cities_cash_pay)
      yield response.body[:get_cities_cash_pay_response][:return] if response.success? && block_given?
      raise unless response.success?
    end

    def get_shops(city_code = nil)
      response = call(:get_parcel_shops, city_code ? {cityCode: city_code} : {})
      yield response.body[:get_parcel_shops_response][:return][:parcel_shop] if response.success? && block_given? 
      response.success?
    end

    def get_terminals()
      response = call_simple(:get_terminals_self_delivery2)
      yield response.body[:get_terminals_self_delivery2_response][:return][:terminal] if response.success? && block_given? 
      response.success?
    end

    def get_service_cost(pickup_city, delivery_city, weight, service:, self_delivery:)
      params = {
        pickup: {
          cityId: pickup_city
        },
        delivery: {
          cityId: delivery_city
        },
        selfPickup: false,
        selfDelivery: self_delivery,
        weight: weight, 
        serviceCode: service.respond_to?(:join) ? service.join(',') : service
      }
      response = call(:get_service_cost2, params, :calc)
      return response.success? ? response.body[:get_service_cost2_response][:return] : nil  
    end

  end
end