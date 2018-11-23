StellarBase::Engine.routes.draw do
  resources :bridge_callbacks, only: [:create], defaults: { format: "json" }
  get "/withdraw" => "withdraw#create", as: :withdraw
  get "/deposit" => "deposit#create", as: :deposit
  get "/balance/:asset_code" => "balances#show", as: :balance
end

