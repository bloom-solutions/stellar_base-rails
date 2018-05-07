require "spec_helper"

describe "POST /bridge_callbacks", type: :request, vcr: { record: :once } do
  let(:uri) do
    StellarBase::Engine.routes.url_helpers.bridge_callbacks_path
  end

  context "successful callback class" do
    it "triggers the configured .on_bridge_callback class" do
      params = {
        id: "OPERATION_ID_1234",
        from: "GABCSENDERXLMADDRESS",
        route: "RECIPIENTROUTE",
        amount: 100.00,
        asset_code: "XLM",
        asset_issuer: "GABCASSETISSUER",
        memo_type: "id",
        memo: "2",
        data: "DATAHASH",
        transaction_id: "TRANSACTION_ID_1234",
      }

      post uri, params: params

      expect(response).to be_success
      expect(response.code.to_i).to eq 200
    end
  end


  context "failed callback class" do
    before do
      StellarBase.configure do |c|
        c.on_bridge_callback = "ProcessFailedBridgeCallback"
      end
    end

    after do
      StellarBase.configure do |c|
        c.on_bridge_callback = "ProcessBridgeCallback"
      end
    end

    it "triggers the configured .on_bridge_callback class" do
      params = {
        id: "OPERATION_ID_1234",
        from: "GABCSENDERXLMADDRESS",
        route: "RECIPIENTROUTE",
        amount: 100.00,
        asset_code: "XLM",
        asset_issuer: "GABCASSETISSUER",
        memo_type: "id",
        memo: "2",
        data: "DATAHASH",
        transaction_id: "TRANSACTION_ID_1234",
      }

      post uri, params: params

      expect(response.success?).to eq false
      expect(response.code.to_i).to eq 422
    end
  end

  context "fake transaction" do
    before do
      StellarBase.configure do |c|
        c.check_bridge_callbacks_authenticity = true
      end
    end

    after do
      StellarBase.configure do |c|
        c.check_bridge_callbacks_authenticity = false
      end
    end

    context "operation doesn't exist" do
      it "returns 422" do
        params = {
          id: "OPERATION_ID_1234",
          from: "GABCSENDERXLMADDRESS",
          route: "RECIPIENTROUTE",
          amount: 100.00,
          asset_code: "XLM",
          asset_issuer: "GABCASSETISSUER",
          memo_type: "id",
          memo: "2",
          data: "DATAHASH",
          transaction_id: "TRANSACTION_ID_1234",
        }

        post uri, params: params

        expect(response.success?).to eq false
        expect(response.code.to_i).to eq 422
      end
    end

    context "transaction doesn't exist" do
      it "returns 422" do
        params = {
          id: "37587135708020737",
          from: "GABCSENDERXLMADDRESS",
          route: "RECIPIENTROUTE",
          amount: 100.00,
          asset_code: "XLM",
          asset_issuer: "GABCASSETISSUER",
          memo_type: "id",
          memo: "2",
          data: "DATAHASH",
          transaction_id: "TRANSACTION_ID_1234",
        }

        post uri, params: params

        expect(response.success?).to eq false
        expect(response.code.to_i).to eq 422
      end
    end

    context "callback details aren't the same with existing operation/transaction" do
      it "returns 422" do
        params = {
          id: "37587135708020737",
          from: "GDORX35OXMJXSYI6HXO2URB5K3GW7UPVB5WR7YC36HAMS2EQEQGDIRKT",
          route: "BX857D13E",
          amount: "200.0000000",
          asset_code: "",
          asset_issuer: "",
          memo_type: "text",
          memo: "BX857D13E",
          data: "",
          transaction_id: "4685b3b43512be87586832214da1d3ccd45c4098c2d90b8e3539866debe9652f",
        }

        post uri, params: params

        expect(response.success?).to eq false
        expect(response.code.to_i).to eq 422
      end
    end
  end

  context "X_PAYLOAD_MAC is configured to be checked" do
    before do
      StellarBase.configure do |c|
        c.check_bridge_callbacks_mac_payload = true
        c.bridge_callbacks_mac_key = "SDYOGCQL6HLTPZUDYDH7E3YST2AGZR3PJZXED62N42FJA6AWXDP3FSCA"
      end
    end

    after do
      StellarBase.configure do |c|
        c.check_bridge_callbacks_mac_payload = false
      end
    end

    let(:params) do
      {
        id: "37587135708020737",
        from: "GDORX35OXMJXSYI6HXO2URB5K3GW7UPVB5WR7YC36HAMS2EQEQGDIRKT",
        route: "BX857D13E",
        amount: "200.0000000",
        asset_code: "",
        asset_issuer: "",
        memo_type: "text",
        memo: "BX857D13E",
        data: "",
        transaction_id: "4685b3b43512be87586832214da1d3ccd45c4098c2d90b8e3539866debe9652f",
      }
    end

    let(:encoded_payload) do
      payload = OpenSSL::HMAC.digest("SHA256", mac_key, params.to_json)
      Base64.encode64(payload)
    end

    let(:headers) { { "HTTP_X_PAYLOAD_MAC" => encoded_payload } }

    context "doesn't match" do
      let(:mac_key) { "1234" }

      it "renders 422" do
        post uri, params: params, headers: headers

        expect(response.success?).to eq false
        expect(response.code).to eq "400"
      end
    end

    context "it matches" do
      let(:mac_key) { "SDYOGCQL6HLTPZUDYDH7E3YST2AGZR3PJZXED62N42FJA6AWXDP3FSCA" }

      it "continues to process the payload" do
        post uri, params: params, headers: headers

        expect(response.success?).to eq true
        expect(response.code).to eq "200"
      end

    end
  end

end
