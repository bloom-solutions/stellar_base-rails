module StellarBase
  class GenRandomString

    def self.call(length:)
      o = [(0..9), ('A'..'Z')].map(&:to_a).flatten
      string = (0...length).map { o[rand(o.length)] }.join
    end

  end
end
