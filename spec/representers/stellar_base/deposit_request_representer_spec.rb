require 'spec_helper'

module StellarBase
  RSpec.describe DepositRequestRepresenter do

    it "exposes the attributes" do
      deposit = build_stubbed(:stellar_base_deposit_request, {
        deposit_address: "BTC-ADDR",
        eta: 600,
        min_amount: 0.0,
        max_amount: 100.0,
        fee_fixed: 0,
        fee_percent: 0,
        extra_info: {here: "extra"}.to_json,
      })

      twin = DepositRequestTwin.new(deposit)
      representer = described_class.new(twin)
      serialized = representer.as_json.with_indifferent_access

      expect(serialized[:how]).to eq "BTC-ADDR"
      expect(serialized[:eta]).to eq 600
      expect(serialized[:min_amount].to_d).to eq 0.0
      expect(serialized[:max_amount].to_d).to eq 100.0
      expect(serialized[:fee_fixed].to_d).to eq 0
      expect(serialized[:fee_percent].to_d).to eq 0
      expect(serialized[:extra_info]["here"]).to eq "extra"
    end

    context "extra_info is blank" do
      let(:deposit_request) do 
        build_stubbed(:stellar_base_deposit_request, {
          extra_info: "",
        })
      end

      it "renders `extra_info` as an empty JSON object" do
        twin = DepositRequestTwin.new(deposit_request)
        representer = described_class.new(twin)
        serialized = representer.as_json.with_indifferent_access

        expect(serialized[:extra_info]).to eq({})
      end
    end

    context "extra_info is not parsable to JSON" do
      let(:deposit_request) do 
        build_stubbed(:stellar_base_deposit_request, {
          extra_info: "Hullo",
        })
      end

      it "renders `extra_info` as an empty JSON object" do
        twin = DepositRequestTwin.new(deposit_request)
        representer = described_class.new(twin)
        serialized = representer.as_json.with_indifferent_access

        expect(serialized[:extra_info]).to eq({})
      end
    end

  end
end
