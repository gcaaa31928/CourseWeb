class Api::NotificationController < ApplicationController
    def get_logs
        permitted = params.permit(:after_time)
        permitted[:after_time] ||= Time.now.to_i
        notifications = Notification.where("created_at >= #{Time.at(permitted[:after_time].to_i).utc.iso8601}")
        render HttpStatusCode.ok(
            notifications.as_json(only: [:id, :text, :created_at])
        )
    end
end
