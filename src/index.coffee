route = exports ? (@['route'] = {})

class route.Router
    constructor: ->
        @routes = []
        @params = ['path']
    
    add: (expr, fn) ->
        if typeof expr is 'object'
            routes = expr
        else
            routes = {}
            routes[expr] = fn
            
        for expr, fn of routes
            pattern = "^#{expr}$"
            
            # Escape URL Special Characters
            pattern = pattern.replace(/([?=,\/])/g, '\\$1')
            
            # Replace params with group captures
            pattern = pattern.replace /(:|*)([\w\d]+)/g, (all, op, name) ->
                @params.push(name)
                if op == ':'
                    return '([^/]*)'
                else
                    return '(.*?)'

            pattern = pattern.replace /:([\w\d]+)/g, (all, name) ->
                @params.push(name)
                return '([^/]*)'
        
            @routes.push({ expr: expr, pattern: new RegExp(pattern), fn: fn })

        return

    run: (path, context, one) ->
        results = []
    
        for route in @routes
            if (m = route.pattern.exec(path))
                args = {}
                for value, i in m
                    args[@params[i]] = value
                
                results.push(route.fn.call(context, args))
                
                return results[0] if one
                
        return results