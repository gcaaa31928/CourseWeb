angular.module('courseWebApp').factory 'Admin', [
    '$http',
    '$q',
    '$localStorage'
    ($http, $q, $localStorage) ->
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

        factory.listStudentWithoutGroup = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/' + courseId + '/students/list_without_group', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.allCourse = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/all', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.allGroup = (courseId, canceler = null) ->
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

        factory.createCourseStudent = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/create_course_students', {
                    course_id: courseId
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ),(response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.isLogin = () ->
            factory.accessToken?
        factory
]