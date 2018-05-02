StellarBase::Engine.routes.draw do
  if StellarBase.included_module?(:bridge_receive)
    resources :bridge_callbacks, only: [:create], defaults: :json
  end
end

