class CreateGitJob < ActiveJob::Base
    queue_as :default

    APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
    def perform(project)
        git_app = APP_CONFIG['git_app']
        system("#{git_app} --git-dir=#{APP_CONFIG['git_project_root']}oopcourse#{project.id}.git init")
    end

    def self.create_test
        git_app = APP_CONFIG['git_app']
        for i in 1..60
            system("#{git_app} --git-dir=#{APP_CONFIG['git_project_root']}/test/oopcourse#{i}.git init")
        end
    end
end
