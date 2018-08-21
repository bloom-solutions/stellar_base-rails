require 'spec_helper'

module StellarBase
  module WithdrawalRequests
    RSpec.describe GenMemo do

      it "generates an unused memo" do
        # Can't actually test "unused"...?
        expect(described_class.().length).to eq 8
        expect(described_class.()).to_not eq described_class.()
      end

    end
  end
end
