return {
  ["tweet"] = function(args, kwargs)
    
    local id = pandoc.utils.stringify(kwargs["id"])
    
    local open_bquote = '<blockquote class="twitter-tweet">'
    local href = '<a href="https://twitter.com/x/status/' .. id .. '"></a> '
    local close_bquote = '</blockquote>'
    
    local js = '<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>'
    
    local html = open_bquote .. '\n' .. href .. '\n' .. close_bquote .. '\n'.. js
    
    return pandoc.RawBlock('html', html)
  end,
  
  ["hardcode"] = function(args, kwargs)
    
    local id = pandoc.utils.stringify(kwargs["id"])
    
    local html = [[
    <blockquote class="twitter-tweet"><p lang="en" dir="ltr">New paper on Bayesian subset selection now in JMLR! <br><br>1) How does decision analysis work for Bayesian subset selection? <br>2) Why does a *Bayesian* model help?<br>3) What do you do about the many &quot;near-optimal&quot; subsets? <a href="https://t.co/oRNIHMrZUb">https://t.co/oRNIHMrZUb</a></p>&mdash; Daniel Kowal (@Daniel_R_Kowal) <a href="https://twitter.com/Daniel_R_Kowal/status/1523686133552480258?ref_src=twsrc%5Etfw">May 9, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 
    ]]
    
    return pandoc.RawBlock('html', html)
  end
}
