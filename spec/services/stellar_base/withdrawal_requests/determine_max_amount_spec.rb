require "spec_helper"

module StellarBase
  module WithdrawalRequests
    RSpec.describe DetermineMaxAmount do
      context "given a class name" do
        it "runs that class" do
          expect(GetMaxAmount).to receive(:call).and_return(1)
          described_class.(GetMaxAmount.to_s)
        end
      end

      context "given no class name" do
        it "returns nil" do
          expect(described_class.("")).to be_nil
        end
      end
    end
  end
end
