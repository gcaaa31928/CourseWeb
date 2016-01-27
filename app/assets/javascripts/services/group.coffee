angular.module('courseWebApp').factory 'Group' ,[
    () ->
        # data = [{'id' => 104598038, 'name' => nil}]
        factory = {}
        factory.members = []
        factory.processData = (dataClusters) ->
            factory.members = dataClusters
        factory
]