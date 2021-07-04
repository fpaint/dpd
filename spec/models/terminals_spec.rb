require 'rails_helper'

RSpec.describe Dpd::Terminals, :type => :model do

  before(:each) do
    Mongoid.purge!
  end

  describe 'Import DPD terminals' do
    let(:terminals) { YAML.load_file(File.join(__dir__, "../fixtures/terminals.yml")) }
    let(:locality) { Dpd::Locality.create(name: 'Зарюпинск', region: 99, dpd_id: '12323434500')}
    let(:moscow) { Dpd::Locality.create(name: 'Москва', region: 77, dpd_id: '49694102')}

    it 'Should change terminal city' do
      moscow
      shop = Dpd::Terminal.create(locality: locality, dpd_id: 'M11', name: 'Тестовый ПВЗ', type: :terminal)
      client = double('DpdClient')

      expect(client).to receive(:get_terminals) do |&block|
        block.call(terminals)
      end

      Dpd::Terminals.import_terminals(client)

      shop.reload
      expect(shop.name).to eq('Москва -  M11 Илимская')
      expect(shop.locality).to eq(moscow)
    end

  end

  describe 'Import localities, terminals & shops (slow)' do
    let(:shops) { YAML.load_file(File.join(__dir__, "../fixtures/shops_full.yml")) }
    let(:terminals) { YAML.load_file(File.join(__dir__, "../fixtures/terminals_full.yml")) }
    let(:cities) { YAML.load_file(File.join(__dir__, "../fixtures/localities.yml")) }

    it 'Should import all records' do
      client = double('DpdClient')
      expect(client).to receive(:get_localities) do |&block|
        block.call(cities)
      end
      expect(client).to receive(:get_terminals) do |&block|
        block.call(terminals)
      end
      expect(client).to receive(:get_shops) do |&block|
        block.call(shops)
      end

      Dpd::Localities.import(client)
      expect(Dpd::Locality.count).to eq(17131)       
  
      Dpd::Terminals.import(client)
      expect(Dpd::Terminal.count).to eq(5568)

    end

  end

end