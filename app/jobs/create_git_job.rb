class CreateGitJob < ActiveJob::Base
    queue_as :default

    APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
    def perform(project)
        git_app = APP_CONFIG['git_app']
        system("#{git_app} --git-dir=#{APP_CONFIG['git_project_root']}#{project.id}.git init")
    end
end
