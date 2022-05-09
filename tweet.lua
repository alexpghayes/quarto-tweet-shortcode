function fallback(url)

  local open_bquote = '<blockquote class="twitter-tweet">\n'
  local href = '<a href="' .. url .. '"></a>\n'
  local close_bquote = '</blockquote>\n'
  local js = '<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>\n'
  
  local html = open_bquote .. href .. close_bquote .. js
  return pandoc.RawBlock('html', html)
  
end

return {
  ["tweet"] = function(args, kwargs)
    
    local id = pandoc.utils.stringify(kwargs["id"])
    
    local url = 'https://twitter.com/x/status/' .. id
    
    local request = 'https://publish.twitter.com/oembed?url=' .. url
    
    
    local mime_type, contents = pandoc.mediabag.fetch(request)
    
      
    -- if the http request fails, use the fallback option
    if mime_type ~= nil then
      return fallback(url)
    end
      
    print(contents)
    return pandoc.RawBlock('html', contents)
  end,
  
  ["hardcode"] = function(args, kwargs)
    
    local id = pandoc.utils.stringify(kwargs["id"])
    
    local html = [[
    <blockquote class="twitter-tweet"><p lang="en" dir="ltr">New paper on Bayesian subset selection now in JMLR! <br><br>1) How does decision analysis work for Bayesian subset selection? <br>2) Why does a *Bayesian* model help?<br>3) What do you do about the many &quot;near-optimal&quot; subsets? <a href="https://t.co/oRNIHMrZUb">https://t.co/oRNIHMrZUb</a></p>&mdash; Daniel Kowal (@Daniel_R_Kowal) <a href="https://twitter.com/Daniel_R_Kowal/status/1523686133552480258?ref_src=twsrc%5Etfw">May 9, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 
    ]]
    
    return pandoc.RawBlock('html', html)
  end
}
