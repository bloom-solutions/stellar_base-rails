module StellarBase
  class Engine < ::Rails::Engine

    isolate_namespace StellarBase

    config.to_prepare do
      Engine.routes.default_url_options =
        Rails.application.routes.default_url_options
    end

    initializer "register.mime_types" do
      if Mime::Type.lookup_by_extension("toml").blank?
        Mime::Type.register "application/toml", :toml
      end
    end

    config.generators do |g|
      g.test_framework :rspec
    end

  end
end
