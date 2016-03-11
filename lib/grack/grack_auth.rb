module Grack
    class Auth < Rack::Auth::Basic

        attr_accessor :user, :project, :ref, :env

        def call(env)
            @env = env
            @request = Rack::Request.new(env)
            @auth = Request.new(env)

            # Need this patch due to the rails mount
            @env['PATH_INFO'] = @request.path
            @env['SCRIPT_NAME'] = ""

            auth!
        end

        private

        def auth!
            return @app.call(env) if is_test_git?(@request.path_info)
            return render_not_found unless project

            if @auth.provided?
                return bad_request unless @auth.basic?

                # Authentication with username and password
                login, password = @auth.credentials

                @student = authenticate_user(login, password)

                if @student and can_handle_project(@project, @student)
                    # Gitlab::ShellEnv.set_env(@user)
                    @env['REMOTE_USER'] = @auth.username
                else
                    return unauthorized
                end

            else
                return unauthorized
            end

            if authorized_git_request?
                @app.call(env)
            else
                unauthorized
            end
        end

        def authorized_git_request?
            # Git upload and receive
            if @request.get?
                authorize_request(@request.params['service'])
            elsif @request.post?
                authorize_request(File.basename(@request.path))
            else
                false
            end
        end

        def authenticate_user(login, password)
            student = Student.find_by(id: login.to_i)
            if student.nil?
                return nil
            end
            student if student.valid_password?(password)
        end

        def can_handle_project(project, student)
            project.can?(student)
        end

        def authorize_request(service)
            case service
                when 'git-upload-pack'
                    true
                    # Notification.student_action(@student, '從server上pull code')
                when'git-receive-pack'
                    action = if false
                                 :push_code_to_protected_branches
                             else
                                 :push_code
                             end

                    # Notification.student_action(@student, 'push code到server上')
                    true
                else
                    false
            end
        end

        def project_by_path(path)
            if m = /^\/git\/oopcourse([\w\.\/-]+)\.git/.match(path).to_a
                path_with_namespace = m.last
                Project.find_by(id: path_with_namespace.to_i)
            end
        end

        def project
            @project ||= project_by_path(@request.path_info)
        end

        def is_test_git?(path)
            if m = /^\/git\/test\/oopcourse([\w\.\/-]+)\.git/.match(path).to_a
                if m.last
                    return true
                end
            end
            false
        end

        def ref
            @ref ||= parse_ref
        end

        def parse_ref
            input = if @env["HTTP_CONTENT_ENCODING"] =~ /gzip/
                        Zlib::GzipReader.new(@request.body).read
                    else
                        @request.body.read
                    end

            # Need to reset seek point
            @request.body.rewind
            /refs\/heads\/([\w\.-]+)/n.match(input.force_encoding('ascii-8bit')).to_a.last
        end

        def render_not_found
            [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
        end
    end
end