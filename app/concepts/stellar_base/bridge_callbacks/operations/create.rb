module StellarBase
  module BridgeCallbacks
    module Operations
      class Create < ApplicationOperation
        step :model!
        step :assign_operation_id!
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :bridge_callback)
        step Contract::Persist()
        step :process!

        def model!(options, **)
          options["model"] = BridgeCallback.new
        end

        def assign_operation_id!(options, params:, **)
          params[:bridge_callback][:operation_id] = params[:bridge_callback][:id]
        end

        def process!(options, **)
          BridgeCallbacks::Process.(options["model"])
        end
      end
    end
  end
end
