require "spec_helper"

module StellarBase
  RSpec.describe HorizonClient, vcr: { record: :all } do
    describe "#get_operation" do
      context "non-existent transcation" do
        it "returns nil" do
          expect(described_class.new.get_operation("TEST")).to be_nil
        end
      end

      context "existing transaction" do
        it "returns the parsed transaction object" do
          id = "37587135708020737"
          result = described_class.new.get_operation(id)
          expect(result).not_to be_nil
          expect(result["id"]).to eq id
        end
      end

    end
  end
end
