if Rails.configuration.respond_to?(:sass)
  Rails.configuration.sass.tap do |config|
    # Use SASS instead of SCSS
    config.preferred_syntax = :sass
  end
end