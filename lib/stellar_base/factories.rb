Dir[File.join(File.dirname(__FILE__), "factories/*.rb")].each do |f|
  require f
end
