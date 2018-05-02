module StellarBase
  module DryTypes
    include Dry::Types.module
  end

  class ApplicationDataModel < Dry::Struct
    constructor_type :schema
  end
end
