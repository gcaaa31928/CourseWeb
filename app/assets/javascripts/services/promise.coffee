# use async instead of this right now
# so this is not finshed yet

angular.module('courseWebApp').factory 'Promise', [
    '$q',
    ($q) ->
        factory = {}
        factory.queue = []
        factory.executeJob = () ->
            task = factory.queue.pop()

]