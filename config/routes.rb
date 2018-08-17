StellarBase::Engine.routes.draw do
  resources :bridge_callbacks, only: [:create], defaults: { format: "json" }
  get "/withdraw" => "withdraw#create", as: :withdraw
end

