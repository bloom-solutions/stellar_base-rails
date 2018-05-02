StellarBase::Engine.routes.draw do
  if StellarBase.included_module?(:bridge_callbacks)
    resources :bridge_callbacks, only: [:create], defaults: { format: "json" }
  end
end

