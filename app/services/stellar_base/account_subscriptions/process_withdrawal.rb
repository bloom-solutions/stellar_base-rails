module StellarBase
  module AccountSubscriptions
    class ProcessWithdrawal

      extend LightService::Action
      expects :stellar_operation

      executed do |c|
        WithdrawalRequests::Process.(c.stellar_operation)
      end

    end
  end
end
