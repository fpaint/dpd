require 'rails_helper'

RSpec.describe Dpd::Convertion, :type => :model do

  describe 'Import DPD parcel shops' do
    let(:shops) { YAML.load_file(File.join(__dir__, "../fixtures/shops.yml")) } 
  
    it 'Should convert regular shop entry' do
      info = Dpd::Convertion.shop_hash(shops[0])
      expect(info).to eq({
        dpd_id: '162J',
        type: :parcel_shop,
        street_abbr: "ул",
        address: "Пленкина, 39",
        location: {lat: "56.867847", lng: "35.926566"},
        card_payment: false,
        company: :dpd,
        conditions: true,
        description: 'Пункт выдачи "220 Вольт"',
        max_weight: 15,
        name: "220 вольт",
        payment: true
      })
      shop = Dpd::Terminal.create(info)
      expect(shop.location.to_hsh).to eq({x: 35.926566, y: 56.867847})
    end
    
    it 'Should convert shop entry with no limits and one service' do   
      info = Dpd::Convertion.shop_hash(shops[1])
      expect(info).to include({
        max_weight: 0,
        conditions: false,
        payment: true,
        card_payment: true
      })
    end  

  end

  describe 'Import DPD terminals' do
    let(:terminals) { YAML.load_file(File.join(__dir__, "../fixtures/terminals.yml")) }

    it 'Should convert terminal entry' do
      info = Dpd::Convertion.terminal_hash(terminals[0])
      expect(info).to eq({
        company: :dpd,
        dpd_id: "M11",
        type: :terminal,
        name: "Москва -  M11 Илимская",
        street_abbr: "улица",        
        address: "Касаткина, 11 к3",
        location: {lat: "55.826581", lng: "37.660667"},
        description: "",
        card_payment: true,
        conditions: true,
        payment: true,
        max_weight: 0
      })      
    end

  end

end