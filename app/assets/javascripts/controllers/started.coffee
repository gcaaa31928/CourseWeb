angular.module('courseWebApp').controller 'StartedCtrl', [
    '$scope',
    '$timeout',
    '$http',
    '$state'
    'Admin',
    'Student'
    ($scope, $timeout, $http, $state, Admin, Student) ->
        $timeout ->
            $('.parallax').parallax()
        $scope.from =
            id: ''
            password: ''

        processLogin = (data) ->
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
                        processLogin(data)
                    else
                ), (response) ->
                    Materialize.toast("學號或是密碼不正確", 2000)

]