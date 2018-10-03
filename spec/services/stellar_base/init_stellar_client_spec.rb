require "spec_helper"

module StellarBase
  RSpec.describe InitStellarClient do
    it "initializes the Stellar SDK client in the context" do
      result = described_class.execute
      client = result.stellar_sdk_client

      expect(client).to be_a Stellar::Client
      expect(client.horizon._url).to eq StellarBase.configuration.horizon_url
    end
  end
end
