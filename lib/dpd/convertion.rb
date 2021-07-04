module Dpd

  class Convertion

    class << self

      def shop_hash(item)
        return {
          company: :dpd,
          dpd_id: item[:code],
          name: item[:brand],
          type: type_value(item[:parcel_shop_type]),
          address: address_string(item[:address]),
          street_abbr: item[:address][:street_abbr],
          description: item[:address][:descript],
          max_weight: max_weight(item[:limits]),
          conditions: has_conditions?(item[:extra_service]),
          payment: has_payment?(item[:schedule]),
          card_payment: has_card_payment?(item[:schedule]),
          location: location(item[:geo_coordinates])
        }
      rescue StandartError => e
        puts e.message, item.inspect
      end

      def terminal_hash(item)
        return {
          company: :dpd,
          dpd_id: item[:terminal_code],
          name: item[:terminal_name],
          type: :terminal,
          address: address_string(item[:address]),
          street_abbr: item[:address][:street_abbr],
          description: item[:address][:descript] || '',
          payment: has_payment?(item[:schedule]),
          card_payment: has_card_payment?(item[:schedule]),
          max_weight: max_weight(item[:limits]),
          conditions: has_conditions?(item[:extra_service]),
          location: location(item[:geo_coordinates])
        }
      rescue StandartError => e
        puts e.message, item.inspect, $/
      end

      def max_weight(limits)
        (limits and limits[:max_weight]) ? limits[:max_weight].to_i : 0
      end

      def type_value(parcel_shop_type)
        case(parcel_shop_type)
        when 'ПВП' then :parcel_shop
        when 'П' then :postmate
        else :unknown
        end
      end

      def address_string(address)
        "#{address[:street]}, #{house_no(address)}"
      end

      def house_no(address)
        no = address.slice(:house_no, :structure, :building, :ownership)
        no[:structure] = 'к'+no[:structure] if no[:house_no] and no[:structure] 
        no.values.join(' ')
      end

      def has_conditions?(service)
        has_service?(service, 'ТРМ')
      end

      def has_service?(service, code)
        return false unless service
        if service.kind_of?(Array) 
          return (service.any? {|i| i[:es_code] == code})
        elsif service.kind_of?(Hash)
          return service[:es_code] == code
        end
        false    
      end

      def has_payment?(schedule)
        has_schedule?(schedule, 'Payment')
      end

      def has_card_payment?(schedule)
        has_schedule?(schedule, 'PaymentByBankCard')
      end

      def has_schedule?(schedule, operation)
        return false unless schedule
        if schedule.kind_of?(Array)
          return (schedule.any? {|i| i[:operation] == operation})
        elsif schedule.kind_of?(Hash)
          return schedule[:operation] == operation
        end
        false
      end

      def location(coords)
        return {
          lat: coords[:latitude],
          lng: coords[:longitude]
        }
      end  
      
      def clear(val)
        return val.to_s if val.is_a?(Nori::StringWithAttributes)
        return val.transform_values{|i| clear i} if val.respond_to?(:transform_values)
        return val.map{|i| clear i} if val.respond_to?(:map)
        val
      end 

    end
  end
end