module Dpd

  class Locality 
    include Mongoid::Document

    field :dpd_id
    field :name
    field :region, type: Integer
    field :abbr
    field :courier, type: Boolean, default: false 
    has_many :terminals, inverse_of: :locality, order: :address.asc

    index({dpd_id: 1}, {unique: true})

    def region_name
      Dpd::Region::NAMES[region]
    end

  end

end  