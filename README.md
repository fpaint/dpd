# Dpd

DPD API client module, extracted to the gem from a project.
It use mongoid as a storage. I do not plan supporting other storage options. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dpd'
```

Also, you need to specify access options in .env file:

```
DPD_ENDPOINT=http://ws.dpd.ru/services/geography2?wsdl
DPD_CALC_ENDPOINT=http://ws.dpd.ru/services/calculator2?wsdl
DPD_CLIENT_NUMBER=<CLIENT_NUMBER>
DPD_CLIENT_KEY=<CLIENT_KEY>
```

## Usage

First of all, it have two models with useful data inside. `Dpd::Locality` is a collection of localities, 
supported by DPD. `Dpd::Terminal` is a collection of all DPD parcel shops. Not all of the localities have a parcel shops. 

To fill the collections with actual data from DPD API use rake tasks: 

```
rake dpd:import:localities
...and then...
rake dpd:import:terminals
```

Search locality by a part of the name: 

```ruby
Dpd::Localities.search('мос') # returns a list of cities started with 'мос'
```

Select parcel shops of a city with weight limit:

```ruby
city = Ddp::Locality.where(dpd_id: some_dpd_id).first
city.terminals.weight_limit(30).to_a # list of terminals wich allow 30kg weight parcels 
```

Calculate delivery price:

```ruby
pickup_city = 48951627 # source locality dpd_id
delivery_city = 49052007 # destination locality dpd_id
weight = 30 # parcel weight in kg
service = ['MXO', 'ECN', 'PCL', 'CSM'] # delivery tariffs your company use
self_delivery = true # false for courier delivery, true - customer should walk to a parcel shop  
client = Dpd::Client.new
client.get_service_cost(pickup_city, delivery_city, weight, service: service, self_delivery: self_delivery)
# returns a list of services and corresponding prices
```

# Development

To test the gem just clone the repo and run `rspec`.