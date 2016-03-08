class Api::ProjectController < ApplicationController

    def create
        retrieve_student
        permitted = params.permit(:name, :description, :type, :ref_url)
        group = @student.group
        if group.nil?
            raise '你目前並沒有任何團隊'
        end
        Project.transaction do
            project = Project.new(name: permitted[:name],
                                  description: permitted[:description],
                                  project_type: permitted[:type],
                                  ref_url: permitted[:ref_url],
                                  group_id: group.id)
            project.save!
            CreateGitJob.perform_later(project)
        end
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def edit
        retrieve_student
        permitted = params.permit(:id, :name, :description, :type, :ref_url)
        group = @student.group
        project = Project.find_by(id: group.project.id)
        if project.nil?
            raise '沒有這個專案'
        end
        project.update_attributes(name: permitted[:name],
                                  description: permitted[:description],
                                  project_type: permitted[:type],
                                  ref_url: permitted[:ref_url],
                                  group_id: group.id)
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def destroy
        retrieve_student
        group = @student.group
        if group.nil?
            raise '你沒有團隊為什麼會有專案想要刪除'
        end
        project = group.project
        if project.nil?
            raise '你目前沒有專案'
        end
        project.update_attributes(group_id: nil)
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def show
        retrieve_student
        group = @student.group
        if group.nil?
            raise '你目前沒有團隊'
        end
        project = group.project
        render HttpStatusCode.ok(project.as_json(only: [:id, :name, :ref_url, :project_type, :description]))
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def all
        projects = Project.all.includes(:group)
        render HttpStatusCode.ok(projects.as_json(
            include: {
                group: {
                    include: {
                        students: {
                            only: [:id, :name]
                        }
                    },
                    only: :id
                }
            }, only: [:id, :name])
        )
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end


    private

    def retrieve_student
        require_headers
        @student = Student.find_by(access_token: @access_token)
        if @student.nil?
            raise '憑證失效'
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
