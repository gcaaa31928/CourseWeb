namespace :create_test_log do
    task :process => :environment do
        desc "created test logs"
        loop do
            Notification.send_message(Time.now.to_i)
            sleep(1)
        end
    end
end
