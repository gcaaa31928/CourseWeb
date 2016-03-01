class Api::ScoreController < ApplicationController

    def create
        retrieve_admin
        permitted = params.permit(:project_id, :point, :no)
        if @teaching_assistant.nil?
            raise '此為admin帳號，請登入助教帳號再送出分數'
        end
        score = Score.find_by(project_id: permitted[:project_id],
                              teaching_assistant_id: @teaching_assistant.id,
                              no: permitted[:no])
        if score
            score.point = permitted[:point].to_i
            score.save!
        else
            Score.create!(project_id: permitted[:project_id],
                          teaching_assistant_id: @teaching_assistant.id,
                          point: permitted[:point].to_i,
                          no: permitted[:no])
        end
        render HttpStatusCode.ok
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def all
        retrieve_admin
        permitted = params.permit(:project_id, :no)
        scores = Score.where(project_id: permitted[:project_id].to_i,
                             no: permitted[:no].to_i)
        # Log.info(scores[0].teaching_assistant.to_json)
        render HttpStatusCode.ok(scores.as_json(
            include: {
                teaching_assistant: {
                    only: [:id, :name]
                }
            }, only: [:point, :no]
        ))
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    private

    def retrieve_admin
        require_headers
        if @access_token.present?
            @teaching_assistant = TeachingAssistant.find_by(access_token: @access_token)
            @admin = Admin.find_by(access_token: @access_token)
        end
        if @teaching_assistant.nil? and @admin.nil?
            raise '憑證失效'
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
