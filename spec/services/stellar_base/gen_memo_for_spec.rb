require 'spec_helper'

module StellarBase
  RSpec.describe GenMemoFor do

    it "generates an unused memo for a StellarBase ActiveRecord class" do
      # Can't actually test "unused"...?
      klass = WithdrawalRequest
      expect(described_class.(klass).length).to eq 8
      expect(described_class.(klass)).to_not eq described_class.(klass)
    end

  end
end
