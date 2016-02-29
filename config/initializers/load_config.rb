APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
Git.configure do |config|
    # If you want to use a custom git binary
    config.binary_path = APP_CONFIG['git_app']
end