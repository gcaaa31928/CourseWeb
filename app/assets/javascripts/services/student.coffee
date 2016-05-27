angular.module('courseWebApp').factory 'Student', [
    '$http',
    '$q',
    'Group',
    '$localStorage'
    ($http, $q, Group, $localStorage) ->
        factory = {}
        factory.accessToken = $localStorage.me.access_token if $localStorage.me?
        factory.account = $localStorage.me.id if $localStorage.me?
        factory.courseId = $localStorage.me.course_id if $localStorage.me?
        factory.group = null
        factory.httpConfig = (canceler) ->
            timeout = 15 * 1000
            if canceler
                timeout = canceler.promise
            {
                timeout: timeout
                headers: {
                    'AUTHORIZATION': factory.accessToken
                }
            }

        factory.multipartConfig = (canceler, data) ->
            headData = {}
            headData.transformRequest = data
            headData.headers = {}
            headData.headers['Content-Type'] = undefined
            headData.headers['AUTHORIZATION'] = factory.accessToken
            headData


        factory.setInfo = (info) ->
            factory.accessToken = info.access_token if info?
            factory.account = info.id if info?
            factory.courseId = info.course_id if info?

        handleSuccessPromise = (resolve, reject, response) ->
            response = response.data
            if response.data?
                resolve response.data
            else
                resolve null

        handleFailedPromise = (resolve, reject, response) ->
            console.log(response)
            response = response.data
            if response.data? and response.data.errorMsg?
                reject response.data.errorMsg
            else if response.data?
                reject response.data
            else
                reject null

        factory.verifyAccessToken = (canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/verify_student_access_token', {}, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

#        factory.login = (id, password, canceler = null) ->
#            $q (resolve, reject) ->
#                $http.post('/api/student_login', {
#                    id: id
#                    password: password
#                }, factory.httpConfig(canceler)).then ((response) ->
#                    response = response.data
#                    if response.data?
#                        $localStorage.accessToken = response.data.accessToken
#                        resolve response.data
#                    else
#                        resolve response
#                ), (response) ->
#                    response = response.data
#                    if response.data?
#                        reject response.data
#                    else
#                        reject response

        factory.getInfo = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get("/api/student/my_info", factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.ListSudentWithoutGroup = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/' + factory.courseId + '/students/list_without_group', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.createGroup = (studentId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/group/create', {
                    student_id: studentId
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.showGroup = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/group/show', factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        Group.processData(response.data)

                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)



        factory.AllGroup = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/' + factory.courseId + '/group/all', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.allStudents = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/' + factory.courseId + '/students/all', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.allHomeworks = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get("/api/course/#{factory.courseId}/homeworks/all", factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.destroyGroup = (canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/group/destroy', {
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.showProject = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/project/show', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.createProject = (name, refUrl, type, description, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/project/create', {
                    name: name,
                    description: description,
                    type: type,
                    ref_url: refUrl
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.editProject = (name, refUrl, type, description, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/project/edit', {
                    name: name,
                    description: description,
                    type: type,
                    ref_url: refUrl
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.showTimelog = (projectId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/project/' + projectId + '/timelog/all', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.showTimeCosts = (timelogId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get("/api/timelog/#{timelogId}/time_cost/all", factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.editTimelog = (timelogId, todo, canceler = null) ->
            $q (resolve, reject) ->
                $http.post("/api/timelog/#{timelogId}/edit", {
                    todo: todo
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.uploadTimelogImage = (timelogId, image, canceler = null) ->
            $q (resolve, reject) ->
                formData = new FormData();
                formData.append('file', image)
                console.log(timelogId)
                $http.post("/api/timelog/#{timelogId}/upload_image", formData, {
                    transformRequest: image,
                    headers: {
                      'Content-Type': undefined,
                      'AUTHORIZATION': factory.accessToken
                    }
                }).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.addTimeCost = (timelogId, cost, category, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/time_cost/add', {
                    timelog_id: timelogId,
                    cost: cost,
                    category: category
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.destroyTimeCost = (timeCostId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post("/api/time_cost/#{timeCostId}/destroy", {}, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.resetPassword = (password, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/reset_password', {
                    password: Base64.encode(password)
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ),(response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.forgotPassword = (password, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/forgot_password', {
                    password: Base64.encode(password)
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ),(response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.showCommitsChart = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/charts/commits', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.showLocChart = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/charts/line_of_code', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.showTimelogChart = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/charts/timelog', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory
]