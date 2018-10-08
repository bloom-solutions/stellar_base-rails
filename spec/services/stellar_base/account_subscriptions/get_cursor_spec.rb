require "spec_helper"

module StellarBase
  module AccountSubscriptions
    RSpec.describe GetCursor do
      let(:client) { InitStellarClient.execute.stellar_sdk_client }

      context "there is a locally saved cursor" do
        let!(:account_subscription) do
          create(:stellar_base_account_subscription, {
            address: "GAPHLLK32DRM73KYIUMKKTTV5XVG5JND5PAHW7ZBPUW5BVPGJJFWBIMP",
            cursor: "hi",
          })
        end

        it "returns that cursor" do
          resulting_ctx = described_class.execute(
            account_subscription: account_subscription,
            stellar_sdk_client: client,
          )

          expect(resulting_ctx.cursor).to eq "hi"
        end
      end

      context "account does not exist", vcr: { record: :once } do
        let(:account_subscription) do
          create(:stellar_base_account_subscription, address: "ABC")
        end

        it "skips the rest of the actions" do
          resulting_ctx = described_class.execute(
            account_subscription: account_subscription,
            stellar_sdk_client: client,
          )

          expect(resulting_ctx).to be_failure
        end
      end

      context "there is no local cursor and address has operations" do
        # NOTE: This is an account that was created manually on testnet
        let!(:account_subscription) do
          create(:stellar_base_account_subscription, {
            address: "GDLBSJG2GIA6OX3TBI7K7BUIZD762NBNKTX5YFJR3WVWQAIUUM23RW3R",
            cursor: nil,
          })
        end

        it "fetches the latest cursor (latest operation id) for the account", vcr: { record: :once } do
          resulting_ctx = described_class.execute(
            account_subscription: account_subscription,
            stellar_sdk_client: client,
          )

          expect(resulting_ctx.cursor).to be_present
        end
      end
    end
  end
end
