((route) ->
    _routes = []
    _hash = null

    $(document).ready () ->
        $(window).bind 'hashchange', () ->
            hash = $.hash()
            if hash != _hash
                _hash = hash
                route.run(hash)
        
            return
        
        return
    
    route.navigate = (hash, run) ->
        if not run
            _hash = hash
        
        $.hash(hash)
        return
    
    route.run = (hash) ->
        for route in _routes
            if (m = route.pattern.exec(hash))
                route.fn.apply(route, m.slice(1))
                    
        return
    
    route.add = (routes) ->
        for path, fn of routes
            _routes.push(new Route(path, fn))
        
        return
        
    class Route
        _transformations: [
            [ # Named Parameters
                /:([\w\d]+)/g
                '([^/]*)'
            ],
            
            [ # Splat Parameters
                /\*([\w\d]+)/g
                '(.*?)'
            ],
        ]

        constructor: (path, fn) ->
            @path = path
            @fn = fn
            
            for [pattern, replacement] in @_transformations
                path = path.replace(pattern, replacement)
                
            @pattern = new RegExp("^#{path}$")
    

)(exports ? (@['route'] = {}))