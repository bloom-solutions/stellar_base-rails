require 'spec_helper'

module StellarBase
  RSpec.describe GetCallbackFrom do

    context "argument passed is a string" do
      it "returns the constant of that name" do
        result = described_class.("StellarBase::GetCallbackFrom")
        expect(result).to eq GetCallbackFrom
      end
    end

    context "argument passed is a constant" do
      it "returns the constant" do
        result = described_class.(GetCallbackFrom)
        expect(result).to eq GetCallbackFrom
      end
    end

  end
end
