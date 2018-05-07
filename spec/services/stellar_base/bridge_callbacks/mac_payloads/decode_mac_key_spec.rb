require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module MacPayloads
      RSpec.describe DecodeMacKey do
        before do
          StellarBase.configure do |c|
            c.bridge_callbacks_mac_key = "SD4IMOHHYHZKVE3OF3DUAVZJDNYYNOYUB5DYFYKKVB6W36Y7EJ745TCN"
          end
        end

        after do
          StellarBase.configure do |c|
            c.bridge_callbacks_mac_key = "test"
          end
        end

        it "decodes the mac_key" do
          expect(Stellar::Util::StrKey).to receive(:check_decode).with(
            :seed,
            "SD4IMOHHYHZKVE3OF3DUAVZJDNYYNOYUB5DYFYKKVB6W36Y7EJ745TCN"
          ).and_return("decoded")

          result = described_class.execute

          expect(result.decoded_mac_key).to eq "decoded"
        end
      end
    end
  end
end
