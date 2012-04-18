JsRoutes.setup do |config|
  config.exclude = [/admin/, /resque_server/, /rails_info_properties/]
end