class Api::NotificationController < ApplicationController
    def get_logs
        permitted = params.permit(:after_id, :after_time)
        if permitted[:after_time].nil?
            notifications = Notification.where("id > ?", permitted[:after_id].to_i)
            # Log.info(DateTime.current.getutc.to_s)
        else
            notifications = Notification.where("created_at >= ?", Time.at(permitted[:after_time].to_i / 1000).to_datetime.getutc)
        end
        render HttpStatusCode.ok(
            notifications.as_json(only: [:id, :text, :created_at])
        )
    end
end
