module StellarBase
  class GenMemoFor

    LENGTH = 8

    def self.call(klass)
      loop do
        memo = GenRandomString.(length: LENGTH)
        if !klass.exists?(memo: memo)
          return memo
          break
        end
      end
    end

  end
end
