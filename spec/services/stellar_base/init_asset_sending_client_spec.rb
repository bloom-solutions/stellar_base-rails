require "spec_helper"

module StellarBase
  RSpec.describe InitAssetSendingClient do

    context "sending_strategy is `:stellar_sdk`" do
      it "initializes the Stellar SDK client in the context" do
        result = described_class.execute(
          sending_strategy: :stellar_sdk,
          horizon_url: "horizon.com",
        )
        client = result.asset_sending_client

        expect(client).to be_a Stellar::Client
        expect(client.horizon._url).to eq "horizon.com"
      end
    end

    context "sending_strategy is `[:stellar_sdk]`" do
      it "initializes the Stellar SDK client in the context" do
        result = described_class.execute(
          sending_strategy: [:stellar_sdk],
          horizon_url: "horizon.com",
        )
        client = result.asset_sending_client

        expect(client).to be_a Stellar::Client
        expect(client.horizon._url).to eq "horizon.com"
      end
    end

    context "sending_strategy is `[:stellar_spectrum, {...}]`" do
      it "initializes a stellar spectrum client" do
        result = described_class.execute(
          sending_strategy: [
            :stellar_spectrum,
            {redis_url: "redis://lvh.me", seeds: %w(S1 S2)}
          ],
          horizon_url: "horizon.com",
        )
        client = result.asset_sending_client

        expect(client).to be_a StellarSpectrum::Client
        expect(client.redis_url).to eq "redis://lvh.me"
        expect(client.seeds).to match_array(%w(S1 S2))
        expect(client.horizon_url).to eq "horizon.com"
      end
    end

  end
end
