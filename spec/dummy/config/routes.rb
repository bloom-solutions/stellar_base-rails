Rails.application.routes.draw do
  mount StellarBase::Engine => "/stellar_base"
  mount_stellar_base_well_known
end
