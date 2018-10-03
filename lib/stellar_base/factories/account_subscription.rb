FactoryBot.define do

  factory :stellar_base_account_subscription, class: "StellarBase::AccountSubscription" do
    address { Stellar::Account.random.address }
    cursor { nil }
  end

end
