require "spec_helper"

module StellarBase
  RSpec.describe ConfiguredClassRunner do
    context "given a class name" do
      it "runs that class" do
        expect(GetHow).to receive(:call).and_return(1)
        described_class.(GetHow.to_s)
      end
    end

    context "given no class name" do
      it "returns nil" do
        expect(described_class.("")).to be_nil
      end
    end
  end
end
