require "spec_helper"

module StellarBase
  RSpec.describe StellarToml do
    it "offers sensible defaults" do
      stellar_toml = described_class.new(TRANSFER_SERVER: "test.com")

      expect(stellar_toml.TRANSFER_SERVER).to eq "test.com"
    end
  end
end
