require 'http_status_code'
class Api::CommitsController < ApplicationController

    def test
        repo = Rugged::Repository.new("#{APP_CONFIG['git_project_root']}12.git")
        tab = []
        walker = Rugged::Walker.new(repo)
        walker.sorting(Rugged::SORT_DATE)
        walker.push(repo.head.target)
        walker.each do |commit|
            tab.push(commit)
        end
        render HttpStatusCode.ok(count: tab.count)
    end

end
