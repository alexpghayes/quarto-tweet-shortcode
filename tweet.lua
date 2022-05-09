JSON = (loadfile "JSON.lua")()

function isempty(s)
  return s == nil or s == ''
end

function build_request(kwargs)
  local id = pandoc.utils.stringify(kwargs["id"])
  local maxwidth = pandoc.utils.stringify(kwargs["maxwidth"])
  local hide_media = pandoc.utils.stringify(kwargs["hide_media"])
  local hide_thread = pandoc.utils.stringify(kwargs["hide_thread"])
  local omit_script = pandoc.utils.stringify(kwargs["omit_script"])
  local align = pandoc.utils.stringify(kwargs["align"])
  local lang = pandoc.utils.stringify(kwargs["lang"])
  local theme = pandoc.utils.stringify(kwargs["theme"])
  local link_color = pandoc.utils.stringify(kwargs["link_color"])
  local widget_type = pandoc.utils.stringify(kwargs["widget_type"])
  local dnt = pandoc.utils.stringify(kwargs["dnt"])
  
  if isempty(id) then
    error("Must specify id of tweet via `id={tweet_id}` for tweet shortcode.")
  end
  
  -- see https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/get-statuses-oembed
  local request = 'https://publish.twitter.com/oembed?url=https://twitter.com/x/status/' .. id

  if isempty(maxwidth) then
    maxwidth = "550"
  end
  
  request = request .. "&maxwidth=" .. maxwidth
  
  if isempty(hide_media) then
    hide_media = "false"
  end
  
  request = request .. "&hide_media=" .. hide_media
  
  if isempty(hide_thread) then
    hide_thread = "false"
  end
  
  request = request .. "&hide_thread=" .. hide_thread
  
  if isempty(omit_script) then
    omit_script = "false"
  end
  
  request = request .. "&omit_script=" .. omit_script
  
  if isempty(align) then
    align = "none"
  end
  
  request = request .. "&align=" .. align
  
  if isempty(lang) then
    lang = "en"
  end
  
  request = request .. "&lang=" .. lang
  
  if isempty(theme) then
    theme = "light"
  end
  
  request = request .. "&theme=" .. theme
  
  if not isempty(link_color) then
    request = request .. "&link_color=" .. link_color
  end
  
  if not isempty(widget_type) then
    request = request .. "&widget_type=" .. widget_type
  end
  
  if isempty(dnt) then
    dnt = "false"
  end
  
  request = request .. "&dnt=" .. dnt
  return request
end

return {
  ["tweet"] = function(args, kwargs)
    
    -- this is really only designed for HTML output at the moment, not sure
    -- if we can support other types of output
    
    request = build_request(kwargs)
    
    -- possibilities:
    --   1. user has no internet connection
    --   2. requested tweet does not exist
    --   3. tweet info successfully returned from twitter
    
    local success, mime_type, contents = pcall(pandoc.mediabag.fetch, request)
    
    if success then 
    
      if string.find(mime_type, "json") ~= nil then
        -- http request returned json (good) rather than html (bad, 404 error)
        local parsed = JSON:decode(contents)
        return pandoc.RawBlock('html', parsed.html)
      else
        error("Could not find tweet with that tweet id")
      end
    else
      -- in this case mime_type contains error information if you want to use it to debug
      -- print(mime_type)
      error("Could not find contact Twitter to embed tweet. Do you have a working internet connection?")
    end
  end
}
