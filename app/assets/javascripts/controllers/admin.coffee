angular.module('courseWebApp').controller 'AdminCtrl', [
    '$scope',
    'Admin'
    ($scope, Admin) ->
        $scope.showLoginForm = Admin.isLogin()
        $scope.form =
            id: ''
            password: ''

        $scope.login = () ->
            Admin.login($scope.form.id, $scope.form.password).then ((data) ->
                Materialize.toast(data, 4000)
            ), (data) ->
                Materialize.toast("帳號或是密碼不正確", 2000)



]