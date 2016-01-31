angular.module('courseWebApp').controller 'AdminCtrl', [
    '$scope',
    'Admin',
    '$q'
    ($scope, Admin, $q) ->

        q = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)

        $scope.inCourse = false;
        $scope.inCreatingCourse = false;
        $scope.loading = false
        $scope.courses = null
        $scope.requestLoading = false
        $scope.selectedCourse = null


        $scope.createCourse = () ->
            $scope.inCreatingCourse = true
            $scope.inCourse = false

        $scope.form =
            courseId: ""

        $scope.prepareCourse = () ->
            $q (resolve, reject) ->
                $scope.loading = true
                Admin.allCourse().then ((data) ->
                    $scope.courses = data
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()



        $scope.submitCreateCourse = () ->
            $scope.requestLoading = true
            Admin.createCourseStudent($scope.form.courseId).then ((data) ->
                Materialize.toast("建立專案成功", 2000)
                $scope.prepareCourse()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.selectCourse = (course) ->
            $scope.inCourse = true
            $scope.selectedCourse = course


        q.drain = () ->
            $scope.layout.loading = false

        $scope.prepareAll = () ->
            $scope.layout.loading = true
            q.push($scope.prepareCourse)

        $scope.prepareAll()

]