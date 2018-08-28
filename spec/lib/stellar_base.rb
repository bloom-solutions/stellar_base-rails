require 'spec_helper'

RSpec.describe StellarBase do

  describe "configuration" do
    describe "withdraw" do
      it "accepts a Ruby hash" do
        described_class.configuration.withdrawable_assets = [
          {
            type: "crypto",
            network: "ETH",
            asset_code: "ETH",
            issuer: "issuer-address",
            fee_fixed: 0.1,
          }
        ]

        config = described_class.configuration.withdrawable_assets
        expect(config[0][:issuer]).to eq "issuer-address"
      end

      it "accepts JSON" do
        described_class.configuration.withdrawable_assets = [
          {
            type: "crypto",
            network: "ETH",
            asset_code: "ETH",
            issuer: "issuer-address",
            fee_fixed: 0.1,
          }
        ].to_json

        config = described_class.configuration.withdrawable_assets
        expect(config[0][:issuer]).to eq "issuer-address"
      end

      it "accepts a YAML file path" do
        described_class.configuration.withdrawable_assets =
          ROOT_DIR.join("docs/withdraw.yml")

        config = described_class.configuration.withdrawable_assets
        expect(config[1][:issuer]).to eq "G-issuer-on-stellar"
      end
    end
  end

end
