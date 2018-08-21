module StellarBase
  module BridgeCallbacks
    module Operations
      class Create < ApplicationOperation
        step Policy::Pundit(BridgeCallbackPolicy, :create?)
        step :assign_operation_id!
        step :find_model!
        step Model(BridgeCallback, :new)
        step Contract::Build(constant: Contracts::Create)
        step Contract::Validate(key: :bridge_callback)
        step Contract::Persist()
        step :process!

        def find_model!(options, params:, **)
          operation_id = params[:bridge_callback][:operation_id]
          bridge_callback = BridgeCallback.find_by(operation_id: operation_id)
          options["model"] = bridge_callback
          bridge_callback.present? ? Railway.pass_fast! : true
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
