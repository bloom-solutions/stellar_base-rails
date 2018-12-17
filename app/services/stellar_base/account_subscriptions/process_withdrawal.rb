module StellarBase
  module AccountSubscriptions
    class ProcessWithdrawal

      extend LightService::Action
      expects :tx, :operation

      executed do |c|
        WithdrawalRequests::Process.(c.tx, c.operation)
      end

    end
  end
end
