class Api::NotificationController < ApplicationController
    def get_logs
        permitted = params.permit(:after_id)
        permitted[:after_id] ||= 0
        notifications = Notification.where("id > ?", permitted[:after_id])
        render HttpStatusCode.ok(
            notifications.as_json(only: [:id, :text])
        )
    end
end
