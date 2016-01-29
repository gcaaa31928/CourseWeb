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

        processLogin = (data, form) ->
            $localStorage.accessToken = data.accessToken
            $localStorage.account = form.id
            if data.type == 'admin'
                Admin.accessToken = data.accessToken
                $state.go 'main.admin'
            else if data.type == 'student'
                Student.accessToken = data.accessToken
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

]