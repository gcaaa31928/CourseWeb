namespace :create_test_git do
    task :process => :environment do
        desc "Create test git process"
        Log.info("Create test git process...")

        CreateGitJob.create_test
    end
end
