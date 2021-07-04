require 'rails_helper'

RSpec.describe Dpd::Localities, :type => :model do  

  before(:each) do
    Mongoid.purge!
  end

  it 'Should search a city' do 
    Dpd::Locality.create(name: 'Тверь')
    result = Dpd::Localities.search('Москва')
    expect(result.count).to eq(0)
    result = Dpd::Localities.search('Тверь')
    expect(result.count).to eq(1)
    expect(result.first.name).to eq('Тверь')
  end

  it 'Should search by substring' do
    Dpd::Locality.create(name: 'Астрахань')
    result = Dpd::Localities.search('аст')
    expect(result.count).to eq(1)
    expect(result.first.name).to eq('Астрахань')
  end

end