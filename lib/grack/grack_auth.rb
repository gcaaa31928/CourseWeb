module Grack
    class AuthSpawner
        def self.call(env)
            # Avoid issues with instance variables in Grack::Auth persisting across
            # requests by creating a new instance for each request.
            Log.info('in calling')
            Auth.new({}).call(env)
        end
    end
    class Auth < Rack::Auth::Basic
        def call(env)
            @request = Rack::Request.new(env)
            @auth = Request.new(env)
            @env = env
            project_by_path(@request.path_info)
            auth!
            render_grack_auth_ok
        end

        private

        def auth!
        end

        def project
            return @project if defined?(@project)
            Log.info(@request.to_s)
            @project = project_by_path(@request.path_info)
        end

        def project_by_path(path)
            Log.info(path)
            if m = /^([\w\.\/-]+)\.git/.match(path).to_a
                path_with_namespace = m.last
                @path = "./repositories/#{path_with_namespace}.git"
            end
        end

        def render_grack_auth_ok
            [
                200,
                { "Content-Type" => "application/json" },
                [JSON.dump({
                               'GL_ID' => '123456789',
                               'RepoPath' => @path,
                           })]
            ]
        end

        def render_not_found
            [404, { "Content-Type" => "text/plain" }, ["Not Found"]]
        end
    end


end