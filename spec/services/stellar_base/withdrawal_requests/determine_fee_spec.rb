require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe DetermineFee do

      describe ".call" do
        context "given a value" do
          it "returns the value" do
            expect(described_class.(1.0)).to eq 1.0
            expect(described_class.(1.5)).to eq 1.5
          end
        end

        context "given nil" do
          it "returns 0.0" do
            expect(described_class.(nil)).to be_zero
          end
        end
      end

      describe ".network" do
        context "given a value" do
          it "returns the value" do
            expect(described_class.network(:bitcoin, 1.0)).to eq 1.0
            expect(described_class.network(:bitcoin, 1.5)).to eq 1.5
          end
        end

        context "given nil" do
          it "returns 0.0" do
            expect(described_class.network(:bitcoin, nil)).
              to eq described_class::DEFAULT_NETWORK[:bitcoin]

            expect(described_class.network("bitcoin", nil)).
              to eq described_class::DEFAULT_NETWORK[:bitcoin]
          end
        end
      end

    end
  end
end
