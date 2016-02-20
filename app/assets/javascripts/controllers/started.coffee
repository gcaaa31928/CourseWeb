angular.module('courseWebApp').controller 'StartedCtrl', [
    '$scope',
    '$timeout',
    '$http',
    '$state'
    'Admin',
    'Student',
    '$localStorage'
    ($scope, $timeout, $http, $state, Admin, Student, $localStorage) ->
        $timeout ->
            $('.parallax').parallax()
        $scope.form =
            id: ''
            password: ''

        $scope.forgotStudentId = null

        processLogin = (data, form) ->
            $localStorage.me = data.info
            if data.type == 'admin' or data.type == 'ta'
                Admin.setInfo(data.info)
                $state.go 'main.admin'
            else if data.type == 'student'
                Student.setInfo(data.info)
                $state.go 'main.student'

        $scope.login = () ->
            $http.post('/api/login', {
                account: $scope.form.id
                password: Base64.encode($scope.form.password)
            }).then ((response) ->
                response = response.data
                if response.data?
                    data = response.data
                    processLogin(data, $scope.form)
                else
            ), (response) ->
                Materialize.toast("學號或是密碼不正確", 2000)


        $scope.submitForgot = () ->
            $http.post('api/forgot_password', {
                student_id: $scope.forgotStudentId
            }).then ((responses) ->
                Materialize.toast('寄信成功!!', 2000)
            )

        $timeout ->
            $('.modal-trigger').leanModal()

]