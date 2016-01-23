angular.module('courseWebApp').controller 'AdminCtrl', [
    '$scope',
    'Admin'
    ($scope, Admin) ->
        # hack it
        $scope.isLogin = true
        $scope.inCourse = false;
        $scope.inCreatingCourse = false;
#        $scope.isLogin = Admin.isLogin()
        $scope.createCourse = () ->
            $scope.inCreatingCourse = true
            $scope.inCourse = false

        $scope.form =
            courseId: ""

        $scope.login = () ->
            Admin.login($scope.form.id, $scope.form.password).then ((data) ->
                Materialize.toast(data, 4000)
            ), (data) ->
                Materialize.toast("帳號或是密碼不正確", 2000)



        $scope.submitCreateCourse = (course) ->
            $scope.inCreatingCourse = false
            $scope.inCourse = true


]