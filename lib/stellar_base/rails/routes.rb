module ActionDispatch
  module Routing
    class Mapper

      def mount_stellar_base_well_known
        get(
          "/.well-known/stellar" => "stellar_base/home#show",
          :as => :stellar_toml,
          :defaults => { format: "toml" },
        )
      end

    end
  end
end
