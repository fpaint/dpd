require 'rspec/core/rake_task'
namespace :dpd do

  RSpec::Core::RakeTask.new(:spec) do |spec|
    path = File.join(__dir__, '../../spec')
    spec.pattern = "#{path}/*_spec.rb"
  end 

  namespace :import do 

    desc "Import localities from DPD"
    task localities: :environment do
      client = Dpd::Client.new
      Dpd::Localities.import(client)
      puts "#{Dpd::Locality.count} localities"
    end

    desc "Import terminals from DPD"
    task terminals: :environment do
      client = Dpd::Client.new
      Dpd::Terminals.import(client)
      puts "#{Dpd::Terminal.count} terminals"
    end

  end

  task calc: :environment do
    client = Dpd::Client.new
    res = client.get_service_cost('195730113', '195920199', 15, self_delivery: false, service: [])
    puts Dpd::Convertion.clear(res).to_yaml
  end
end    