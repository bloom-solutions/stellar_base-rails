require 'spec_helper'

module StellarBase
  RSpec.describe DetermineExtraInfo do

    context "`extra_info_from` config is properly set" do
      let(:asset_details) do
        {
          asset_code: "BTCT",
          extra_info_from: GetDepositExtraInfo.to_s,
        }
      end

      it "executes the given callback" do
        expect(GetCallbackFrom).to receive(:call)
          .with("GetDepositExtraInfo")
          .and_return(GetDepositExtraInfo)
        expect(GetDepositExtraInfo).to receive(:call)
          .with(asset_details).and_call_original

        result = described_class.(asset_details)

        expect(result[:some]).to eq "hash"
        expect(result[:asset_code]).to eq "BTCT"
      end
    end

    context "`extra_info_from` is not set" do
      let(:asset_details) do
        { }
      end

      it "returns nil" do
        result = described_class.(asset_details)
        expect(result).to be_nil
      end
    end

  end
end
