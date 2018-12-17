require 'spec_helper'

module StellarBase
  RSpec.describe SubscribeAccount do

    let(:account_subscription) do
      create(:stellar_base_account_subscription, {
        address: "GA7ZOD3XBJP4NEUANYRQMOQTTPBXKGC4LMBDBNKNSGI5JGKZFDGMB6IE",
        cursor: "4827543248897",
      })
    end
    let(:on_account_event) do
    end

    it "executes `on_account_event` callback per operation found for the Stellar account", vcr: {record: :once} do
      last_stellar_address = last_tx = last_op = nil
      count = 0

      on_account_event = ->(stellar_address, stellar_op) do
        last_stellar_address = stellar_address
        last_op = stellar_op
        count += 1
      end

      described_class.(account_subscription, {
        operation_limit: 5,
        on_account_event: on_account_event,
      })

      expect(last_stellar_address).to eq account_subscription.address
      expect(last_op.stellar_transaction.transaction_id)
        .to eq "ccc663dd094fa49fae89f63239186979ce5f95de6f31bdc8576e3473413b52d6"
      expect(last_op.operation_id).to eq "6077378727937"
      expect(count).to eq 5
      expect(account_subscription.cursor).to eq last_op.operation_id
    end

  end
end
