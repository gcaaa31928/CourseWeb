sudo RAILS_ENV=production bundle exec rake db:migrate
sudo RAILS_ENV=production bundle exec rake assets:clean
sudo RAILS_ENV=production bundle exec rake assets:clobber
sudo RAILS_ENV=production bundle exec rake assets:precompile
