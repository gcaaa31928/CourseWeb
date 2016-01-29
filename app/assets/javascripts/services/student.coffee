angular.module('courseWebApp').factory 'Student', [
    '$http',
    '$q',
    'Group',
    '$localStorage'
    ($http, $q, Group, $localStorage) ->
        factory = {}
        factory.accessToken = $localStorage.accessToken
        factory.account = $localStorage.account
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


        factory.login = (id, password, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/student_login', {
                    id: id
                    password: password
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        $localStorage.accessToken = response.data.accessToken
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data?
                        reject response.data
                    else
                        reject response

        factory.createGroup = (studentId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/group/create', {
                    student_id: studentId
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data.errorMsg?
                        reject response.data.errorMsg
                    else
                        reject response

        factory.showGroup = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/group/show', factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        Group.processData(response.data)
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data?
                        reject response.data
                    else
                        reject response


        factory.destroyGroup = (canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/group/destroy', {
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data.errorMsg?
                        reject response.data.errorMsg
                    else
                        reject response

        factory.showProject = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/project/show', factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        reject response
                ), (response) ->
                    response = response.data
                    if response.data?
                        reject response.data
                    else
                        reject response

        factory.createProject = (name, refUrl, type, description, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/project/create', {
                    name: name,
                    description: description,
                    type: type,
                    ref_url: refUrl
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data.errorMsg?
                        reject response.data.errorMsg
                    else
                        reject response


        factory.editProject = (name, refUrl, type, description, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/project/edit', {
                    name: name,
                    description: description,
                    type: type,
                    ref_url: refUrl
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data.errorMsg?
                        reject response.data.errorMsg
                    else
                        reject response

        factory.showTimelog = (projectId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/project/' + projectId + '/timelog/all', factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        reject response
                ), (response) ->
                    response = response.data
                    if response.data?
                        reject response.data
                    else
                        reject response

        factory.editTimelog = (timelogId, cost, todo, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/timelog/' + timelogId + '/edit', {
                    cost: cost,
                    todo: todo
                }, factory.httpConfig(canceler)).then ((response) ->
                    response = response.data
                    if response.data?
                        resolve response.data
                    else
                        resolve response
                ), (response) ->
                    response = response.data
                    if response.data.errorMsg?
                        reject response.data.errorMsg
                    else
                        reject response


        factory
]