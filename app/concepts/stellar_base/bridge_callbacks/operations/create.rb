module StellarBase
  module BridgeCallbacks
    module Operations
      class Create < ApplicationOperation
        step :model!
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :bridge_callback)
        step Contract::Persist(method: :sync)
        step :process!

        def model!(options, **)
          options["model"] = BridgeCallback.new
        end

        def process!(options, **)
          BridgeCallbacks::Process.(options["model"])
        end
      end
    end
  end
end
