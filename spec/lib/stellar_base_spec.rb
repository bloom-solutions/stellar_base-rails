require "spec_helper"

RSpec.describe StellarBase do
  describe "configuration" do
    describe "stellar_network" do
      context "no supplied network" do
        it "defaults to testnet" do
          expect(Stellar.current_network).to eq Stellar::Networks::TESTNET
        end
      end

      context "invalid network" do
        after do
          described_class.configuration.stellar_network = "testnet"
        end

        it "raises error" do
          expect {
            described_class.configuration.stellar_network = "etc"
          }.to raise_error(
            ArgumentError,
            "'etc' not a valid stellar_network config",
          )
        end
      end

      context "supplied network" do
        after do
          described_class.configuration.stellar_network = "testnet"
        end

        it "defaults to testnet" do
          described_class.configuration.stellar_network = "public"
          expect(Stellar.current_network).to eq Stellar::Networks::PUBLIC
        end
      end
    end

    describe "withdraw" do
      it "accepts a Ruby hash" do
        described_class.configuration.withdrawable_assets = [
          {
            type: "crypto",
            network: "ETH",
            asset_code: "ETH",
            issuer: "issuer-address",
            fee_fixed: 0.1,
          },
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
          },
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

    describe "#sending_strategy" do
      it "defaults to `:stellar_sdk`" do
        expect(described_class.configuration.sending_strategy).
          to match_array([:stellar_sdk])
      end

      it "can be configured to stellar_sdk" do
        described_class.configuration.sending_strategy = :stellar_sdk

        expect(described_class.configuration.sending_strategy).
          to match_array([:stellar_sdk])
      end

      it "can be configured to stellar_spectrum" do
        described_class.configuration.sending_strategy = [
          :stellar_sdk,
          {
            redis_url: "redis://localhost",
            seeds: ["S1", "S2"],
          }
        ]
        expect(described_class.sending_strategy).to eq `:stellar_sdk`
      end
    end
  end
end
