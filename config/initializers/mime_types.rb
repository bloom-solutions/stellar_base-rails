if Mime::Type.lookup("toml").blank?
  Mime::Type.register "application/toml", :toml
end
