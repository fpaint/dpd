require 'mongoid/geospatial'

module Dpd

  class Terminal
    include Mongoid::Document
    include Mongoid::Geospatial

    TYPES = {
        unknown: '',
        parcel_shop: 'Пункт выдачи',
        postmate: 'Постамат',
        office: 'Офис компании',
        terminal: 'Терминал'
      }

    scope :dpd, -> { where(company: :dpd) } 
    scope :offices, -> { where(:company.ne => :dpd) }
    scope :weight_limit, -> (weight) { any_of([{max_weight: 0}, {:max_weight.gt => weight}]) }
    scope :only_types, -> (types = [:parcel_shop]) { where(:type.in => types)}

    field :dpd_id
    field :name
    field :company, type: Symbol, default: :dpd
    field :type, type: Symbol, default: :unknown
    field :address
    field :street_abbr
    field :description
    field :max_weight, type: Integer
    field :conditions, type: Boolean
    field :payment, type: Boolean, default: false
    field :card_payment, type: Boolean, default: false
    field :location, type: Point, spatial: true

    belongs_to :locality, inverse_of: :terminals, optional: true

    index({dpd_id: 1}, {unique: true})

    def full_address
      "#{locality.name}, #{address_str}"
    end

    def address_str
      street_abbr ? "#{street_abbr}. #{address}" : address
    end


  end
end