angular.module('courseWebApp').factory 'Admin', [
    '$http',
    '$q'
    ($http, $q) ->
        factory = {}
        factory.accessToken = null
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
        factory.login = (account, password, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/login', {
                    account: account
                    password: password
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data?
                        reject response.data
                    else
                        reject response

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