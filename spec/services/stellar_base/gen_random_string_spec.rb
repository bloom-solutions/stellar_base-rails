require 'spec_helper'

module StellarBase
  RSpec.describe GenRandomString do

    it "generates a random string with the given length" do
      result_1 = described_class.(length: 10)
      result_2 = described_class.(length: 20)

      expect(result_1.size).to eq 10
      expect(result_2.size).to eq 20
      expect(result_1).to_not eq result_2
    end

  end
end
