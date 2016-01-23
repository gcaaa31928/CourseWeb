angular.module('courseWebApp').controller 'LoginCtrl', [
    '$scope'
    'Student'
    ($scope, Student) ->
        $scope.layout.sidebar = false
        $scope.form =
            id: ''
            password: ''

        $scope.login = () ->
            Student.login($scope.form.id, $scope.form.password).then ((data) ->
                Materialize.toast(data, 4000)
            ), (data) ->
                Materialize.toast("學號或是密碼不正確", 2000)

]