Emitter = require 'component-emitter'

module.exports = (clazz) ->
    stoppedInstances = []
    eventsStopped = false

    clazz.stopEvents = ->
        eventsStopped = true

    clazz.continueEvents = ->
        eventsStopped = false

        for instance in stoppedInstances
            instance.__continueEvents()

        stoppedInstances.length = 0

    Emitter clazz.prototype
    _emit = clazz.prototype.emit

    clazz.prototype.emit = (type) ->
        if eventsStopped or @__postponedEvents?
            stoppedInstances.push this unless this in stoppedInstances
            @__postponedEvents ?= {}
            @__postponedEvents[type] = arguments
        else
            _emit.apply this, arguments

    clazz.prototype.__continueEvents = ->
        for type, args of @__postponedEvents
            _emit.apply this, args

        @__postponedEvents = null
