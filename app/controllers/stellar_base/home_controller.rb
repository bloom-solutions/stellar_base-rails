module StellarBase
  class HomeController < ApplicationController

    before_action :set_cors_headers, only: %i[show]
    skip_before_action :verify_authenticity_token

    def show
      stellar_toml = StellarToml.new(StellarBase.configuration.stellar_toml)

      respond_to do |f|
        f.toml do
          render plain: ::TomlRB.dump(stellar_toml.to_hash)
        end
      end
    end

    private

    def set_cors_headers
      response.headers["Access-Control-Allow-Origin"] = "*"
    end

  end
end
