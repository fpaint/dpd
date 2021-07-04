module Dpd
  class Railtie < Rails::Railtie
    railtie_name :dpd
    rake_tasks do
      load 'tasks/dpd.rake'
    end
  end
end  