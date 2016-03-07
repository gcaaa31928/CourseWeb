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

        factory.verifyAccessToken = (canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/verify_admin_access_token', {}, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.listStudentWithoutGroup = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/course/' + courseId + '/students/list_without_group', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.allStudents = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get("/api/course/#{courseId}/students/all", factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.allHomeworks = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get("/api/course/#{courseId}/homeworks/all", factory.httpConfig(canceler)).then ((response) ->
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
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.createTimelog = (date, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/timelog/create', {
                    date: date
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.addTeachingAssistant = (id, name, className, courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/add_teaching_assistant', {
                    id: id,
                    name: name,
                    class_name: className,
                    course_id: courseId
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.listTeachingAssistants = (canceler = null) ->
            $q (resolve, reject) ->
                $http.get('/api/teaching_assistant/all', factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.addStudent = (id, name, className, courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/teaching_assistant/add_student', {
                    id: id,
                    name: name,
                    class_name: className,
                    course_id: courseId
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.addHomework = (name, courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/homework/add', {
                    name: name,
                    course_id: courseId
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.handInHomework = (homeworkId, studentId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/homework/hand_in_homework', {
                    homework_id: homeworkId
                    student_id: studentId
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.cancelHandInHomework = (homeworkId, studentId, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/homework/cancel_hand_in_homework', {
                    homework_id: homeworkId
                    student_id: studentId
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.removeStudent = (id, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/teaching_assistant/students/' + id + '/remove', {}, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.resetPassword = (password, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/reset_password', {
                    password: Base64.encode(password)
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.createScore = (projectId, point, number, canceler = null) ->
            $q (resolve, reject) ->
                $http.post('/api/project/'+projectId+'/score/create', {
                    point: point,
                    no: number
                }, factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.allScores = (projectId, number, canceler = null) ->
            $q (resolve, reject) ->
                $http.get("/api/project/#{projectId}/no/#{number}/score/all", factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)

        factory.courseTeachingAssistants = (courseId, canceler = null) ->
            $q (resolve, reject) ->
                $http.get("/api/course/#{courseId}/teaching_assistants/all", factory.httpConfig(canceler)).then ((response) ->
                    handleSuccessPromise(resolve, reject, response)
                ), (response) ->
                    handleFailedPromise(resolve, reject, response)


        factory.isLogin = () ->
            factory.accessToken?
        factory
]