require 'base64'
namespace :create_test_git do
    task :process => :environment do
        Timelog.all.each do |timelog|
            File.open("tmp/timelog/image/#{timelog.id}.png") do |file|
                file.write(Base64.decode64(timelog.image))
            end
            timelog.image
        end
    end
end
