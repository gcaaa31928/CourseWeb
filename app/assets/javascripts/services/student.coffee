angular.module('courseWebApp').factory 'Student', [
    '$http',
    '$q'
    ($http, $q) ->
        factory = {}
        factory.accessToken = ""
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
        factory.login = (id, password, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/student_login', {
                    id: id
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

        factory
]