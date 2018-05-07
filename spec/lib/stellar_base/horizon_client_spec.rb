require "spec_helper"

module StellarBase
  RSpec.describe HorizonClient, vcr: { record: :once } do
    describe "#get_operation" do
      context "non-existent operation" do
        it "returns nil" do
          expect(described_class.new.get_operation("TEST")).to be_nil
        end
      end

      context "existing operation" do
        it "returns the parsed operation object" do
          id = "37587135708020737"
          result = described_class.new.get_operation(id)
          expect(result).not_to be_nil
          expect(result["id"]).to eq id
        end
      end

    end

    describe "#get_transaction" do
      it "returns the parsed transaction object" do
        id = "4685b3b43512be87586832214da1d3ccd45c4098c2d90b8e3539866debe9652f"
        result = described_class.new.get_transaction(id)
        expect(result).not_to be_nil
        expect(result["id"]).to eq id
      end

    end
  end
end
