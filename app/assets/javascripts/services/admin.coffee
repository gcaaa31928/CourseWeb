angular.module('courseWebApp').factory 'Admin', [
    '$http',
    '$q'
    ($http, $q) ->
        factory = {}
        factory.accessToken = $localStorage.me.access_token if $localStorage.me?

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

        factory.setInfo = (info) ->
            factory.accessToken = info.access_token if info?

        handleSuccessPromise = (resolve, reject, response) ->
            response = response.data
            if response.data?
                resolve response.data
            else
                resolve null

        handleFailedPromise = (resolve, reject, response) ->
            response = response.data
            if response.data? and response.data.errorMsg?
                reject response.data.errorMsg
            else if response.data?
                reject response.data
            else
                reject null

        factory.ListSudentWithoutGroup = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/' + courseId + '/students/list_without_group', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.AllGroup = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/' + courseId + '/group/all', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.showTimelog = (projectId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/project/' + projectId + '/timelog/all', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.createCourseStudent = (classId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/get_course_students', {
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        resolve response
                ),(response) ->
                    response = response.data
                    if response.data?
                        reject response.data
                    else
                        reject response

        factory.isLogin = () ->
            factory.accessToken?
        factory
]