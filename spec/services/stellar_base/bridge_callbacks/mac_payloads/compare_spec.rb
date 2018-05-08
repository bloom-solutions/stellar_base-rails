require "spec_helper"

module StellarBase
  module BridgeCallbacks
    module MacPayloads
      RSpec.describe self::Compare do
        context "params and payload doesn't match" do
          it "fails the context and returns a message" do
            result = described_class.execute(
              encoded_params: "TEST",
              decoded_payload: "TEST1",
            )

            expect(result).to be_failure
            expect(result.message)
              .to eq "HTTP_X_PAYLOAD_MAC and encoded raw POST doesn't match"
          end
        end

        context "params and payload matches" do
          it "succeeds the context" do
            result = described_class.execute(
              encoded_params: "TEST",
              decoded_payload: "TEST",
            )

            expect(result.success?).to be true
          end
        end
      end
    end
  end
end
