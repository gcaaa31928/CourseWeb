namespace :create_test_git do
    task :process => :environment do
        desc "Start IMAP process"
        Log.info("Starting an IMAP Client process...")

        CreateGitJob.create_test
    end
end
