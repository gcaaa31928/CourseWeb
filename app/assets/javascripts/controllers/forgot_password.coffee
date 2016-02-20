angular.module('courseWebApp').controller 'ForgotPasswordCtrl', [
    '$scope',
    '$timeout',
    '$http',
    '$state'
    'Admin',
    'Student',
    '$localStorage'
    '$stateParams'
    ($scope, $timeout, $http, $state, Admin, Student, $localStorage, $stateParams) ->
        $scope.token = $stateParams.token
        $scope.passwordForm =
            password: null
            confirmPassword: null

        $scope.submitResetPassword = () ->
            $http.post('api/reset_password_by_token', {
                token: $scope.token
                password: Base64.encode($scope.passwordForm.password)
            }).then ((responses) ->
                Materialize.toast('更改成功!!', 2000)
            ),(response) ->
                data = response.data.data
                Materialize.toast(data.errorMsg)
]