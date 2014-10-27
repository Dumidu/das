class ParsedLocation
    constructor: (url) ->
      @createParser(url)

    # Object.defineProperty(ParsedLocation.prototype, "href", {
    #   get: function() {
    #     @_href = ''
    #       + @protocol
    #       + '//'
    #       + @host
    #       + @_slashifyPathname()
    #       + @_urlifyParams()
    #       + @hash
    #     return @_href
    #   },
    #   set: function(val) {
    #     @createParser(url)
    #   }
    # })

    createParser: (url) ->
      @parser      = document.createElement('a')
      @parser.href = url

      @_href    = url
      @protocol = @parser.protocol
      @hostname = @parser.hostname
      @port     = @parser.port
      @pathname = @parser.pathname
      @search   = @parser.search
      @hash     = @parser.hash
      @username = @parser.username
      @password = @parser.password
      @host     = @parser.host
      @params   = []

      if (@search)
        @_searchToParams()

      @

    _searchToArray: ->
      var cleanedSearch = decodeURI(@search).replace('?', '')
      cleanedSearch.split('&')

    _searchToParams: ->
      var searchParams = @_searchToArray()

      for (i in searchParams)
        if (/=/.test(searchParams[i]))
          var splitParam = searchParams[i].split('=')
          var updateParam = {}
          updateParam[splitParam[0]] = splitParam[1]
          @params.push(updateParam)

    _slashifyPathname: ->
      if (/^\//.test(@pathname))
        return @pathname

      "/#{@pathname}"

    @_urlifyParams: ->
      var urlParams = []

      for (paramPair in @params)
        for (param of paramPair)
          urlParams.push("#{encodeURIComponent(param)}=#{encodeURIComponent(paramPair[param])}")

      if (urlParams.length)
        return "?#{urlParams.join('&')}"

      ""

    updateParams: (updateArray) ->
      for (update in updateArray)
        for (key of update)
          @removeParams(key)
          @params = @params.concat(update)

    removeParams: function(key) ->
      for (var i=0 i<@params.length i++) {
        if (@params[i] && key in @params[i]) {
          delete @params[i]
        }
      }
    }

    return ParsedLocation

  })()
