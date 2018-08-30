require "spec_helper"

module StellarBase
  RSpec.describe StellarToml do
    it "offers sensible defaults" do
      stellar_toml = described_class.new

      expect(stellar_toml.TRANSFER_SERVER)
        .to eq StellarBase::Engine.routes.url_helpers.withdraw_url
    end
  end
end
