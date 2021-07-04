module Dpd

  class Localities

    def self.import(client)
      ids = Locality.pluck(:dpd_id)
      client.get_localities do |cities|
        cities.each do |city|
          data = { dpd_id: city[:city_id], name: city[:city_name], region: city[:region_code].to_i, abbr: city[:abbreviation] }
          if(ids.include?(city[:city_id]))
            Locality.where(dpd_id: city[:city_id]).update(data)
          else
            Locality.create(data)
          end
        end
      end
    end 

    def self.search(str, limit=10)
      re = Regexp.new("^#{Regexp.quote(str)}", true)
      return Locality.where(name: re).limit(limit).to_a
    end

  end

end