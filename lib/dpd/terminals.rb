module Dpd

  class Terminals

    class << self 

      def import(client)
        import_shops(client)
        import_terminals(client)
      end

      def import_shops(client)
        ids = Terminal.pluck(:dpd_id)
        client.get_shops do |items|
          items.each do |item|
            id = item[:code]
            data = Convertion.shop_hash(item)
            city_id = item[:address][:city_id]
            upsert(id, ids, data, city_id)
          end   
        end  
      end

      def import_terminals(client)      
        ids = Terminal.pluck(:dpd_id)
        client.get_terminals do |items|
          items.each do |item|
            id = item[:terminal_code]
            data = Convertion.terminal_hash(item)
            city_id = item[:address][:city_id]
            upsert(id, ids, data, city_id)
          end  
        end
      end

      def upsert(id, ids, data, city_id)
        if(ids.include?(id))
          shop = Terminal.where(dpd_id: id).includes(:locality).first
          data[:locality] = get_locality(city_id) if(shop.locality && shop.locality.dpd_id != city_id)
          shop.update(data)
        else
          data[:locality] = get_locality(city_id)
          Terminal.create(data)
        end        
      end

      private def get_locality(code)
        @city_cache ||= {}
        @city_cache[code] ||= Locality.where(dpd_id: code).first
        @city_cache[code]
      end

    end  
  end
end