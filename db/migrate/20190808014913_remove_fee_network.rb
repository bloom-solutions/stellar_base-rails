class RemoveFeeNetwork < ActiveRecord::Migration[5.2]
  def change
    remove_column(:stellar_base_withdrawal_requests, :fee_network, :decimal, {
      default: "0.0",
      null: false,
    })
  end
end
