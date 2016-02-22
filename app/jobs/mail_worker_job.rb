class MailWorkerJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
        # Do something later
        Log.info('dfsfds')
    end
end
