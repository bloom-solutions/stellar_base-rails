module StellarBase
  module WithdrawalRequests
    class GenMemo

      LENGTH = 8

      def self.call
        loop do
          memo = GenRandomString.(length: LENGTH)
          if !WithdrawalRequest.exists?(memo: memo)
            return memo
            break
          end
        end
      end

    end
  end
end
