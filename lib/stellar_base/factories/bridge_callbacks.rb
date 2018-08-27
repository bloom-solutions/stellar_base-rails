FactoryBot.define do

  factory :stellar_base_bridge_callback, class: "StellarBase::BridgeCallback" do
    sequence(:operation_id) { |n| n.to_s }
    from "from"
    amount 100.0
  end

end
