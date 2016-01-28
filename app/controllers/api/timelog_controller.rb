class Api::TimelogController < ApplicationController
    def all
        permitted = params.permit(:project_id)
        project = Project.find_by(id: permitted[:project_id].to_i)
        if project.nil?
            raise '你沒有任何專案'
        end
        timelogs = project.timelogs
        render HttpStatusCode.ok(timelogs.as_json(
            include: {
                time_cost: {
                    include: {
                        student: {
                            only: :name
                        }
                    },
                    only: [:id, :cost]
                }
            }, only: [:id, :week_no, :date, :todo]
        ))
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end
end
