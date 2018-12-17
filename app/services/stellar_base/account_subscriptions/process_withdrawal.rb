module StellarBase
  module AccountSubscriptions
    class ProcessWithdrawal

      extend LightService::Action
      expects :transaction, :operation

      executed do |c|
        WithdrawalRequests::Process.(c.transaction, c.operation)
      end

    end
  end
end
