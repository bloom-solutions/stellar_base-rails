require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe DetermineHow do
      context "given a class name that needs the params" do
        it "runs that class" do
          result = described_class.(GetHow.to_s, { account_id: "GASD" })
          expect(result).to eq "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2k"
        end
      end

      context "given no class name that doesn't need params" do
        it "returns nil" do
          result = described_class.(GetHowNoArgs.to_s, { account_id: "GASD" })
          expect(result).to eq "2BD"
        end
      end

      context "given no class name" do
        it "returns nil" do
          expect(described_class.("", { account_id: "GASD" })).to be_nil
        end
      end
    end
  end
end
