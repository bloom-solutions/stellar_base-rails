require "spec_helper"

module StellarBase
  RSpec.describe FindAssetDetails do

    context "nil operation" do
      subject { described_class.(operation: nil, asset_code: "hello") }
      it { is_expected.to be_nil }
    end

    context "nil asset_code" do
      subject { described_class.(operation: "deposit", asset_code: nil) }
      it { is_expected.to be_nil }
    end

    context "invalid operation" do
      subject { described_class.(operation: "depositz", asset_code: "BTC") }
      it { is_expected.to be_nil }
    end

    context "deposit asset" do
      subject { described_class.(operation: "deposit", asset_code: "BTCT") }
      # from spec/support/config.rb
      it do
        is_expected.to eq({
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: ENV["ISSUER_ADDRESS"],
          distributor: ENV["DISTRIBUTOR_ADDRESS"],
          distributor_seed: ENV["DISTRIBUTOR_SEED"],
          how_from: GetHow.to_s,
          max_amount_from: GetMaxAmount.to_s,
        })
      end
    end

    context "withdrawable asset" do
      subject { described_class.(operation: "withdraw", asset_code: "BTCT") }
      # from spec/support/config.rb
      it do
        is_expected.to eq({
          type: "crypto",
          network: "bitcoin",
          asset_code: "BTCT",
          issuer: ENV["ISSUER_ADDRESS"],
          max_amount_from: GetMaxAmount.to_s,
          fee_fixed_quote_from: GetWithdrawFeeFixedQuoteFrom,
          fee_fixed_from: GetWithdrawFeeFixedFrom,
        })
      end
    end

  end
end
