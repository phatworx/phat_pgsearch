module PhatPgsearch
  # namespace our plugin and inherit from Rails::Railtie
  # to get our plugin into the initialization process
  class Railtie < Rails::Railtie

    # configure our plugin on boot. other extension points such
    # as configuration, rake tasks, etc, are also available
    initializer "phat_pgsearch.initialize" do |app|


    end
  end
end