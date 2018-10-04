require "spec_helper"

module StellarBase
  module DepositRequests
    RSpec.describe DetermineHow do
      context "given a class name" do
        it "runs that class" do
          expect(GetHow).to receive(:call)
            .with({ account_id: "GASD" })
            .and_return(1)
          described_class.(GetHow.to_s, { account_id: "GASD" })
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
