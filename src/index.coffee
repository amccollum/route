route = exports ? (@['route'] = {})

class route.Router
    _transformations: [
        [ # Escape URL Special Characters
            /([?=,\/])/g
            '\\$1'
        ],

        [ # Named Parameters
            /:([\w\d]+)/g
            '([^/]*)'
        ],

        [ # Splat Parameters
            /\*([\w\d]+)/g
            '(.*?)'
        ],
    ]

    constructor: ->
        @routes = []
    
    add: (routes) ->
        for expr, fn of routes
            pattern = "^#{expr}$"
            for [transformer, replacement] in @_transformations
                pattern = pattern.replace(transformer, replacement)
        
            @routes.push({ expr: expr, pattern: new RegExp(pattern), fn: fn })

        return

    run: (path, context) ->
        results = []
    
        for route in @routes
            if (m = route.pattern.exec(path))
                results.push(route.fn.apply(context, m.slice(1)))
                
        return results
