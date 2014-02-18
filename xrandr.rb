#!/usr/bin/ruby

# as seen here: http://codereview.stackexchange.com/questions/597/autodetecting-monitors-in-xfce

def xrandrPairs (xList)
## Takes a split list of xrandr output and returns [[<display name>, <max-resolution>], ...]
  pairs = [[matchDisplay(xList[0]), matchOption(xList[1])]]
  (2..xList.length-1).to_a.each do |i| # kind of hacky, but I need to reference car and cadr here, so a call to .map won't do it
    if xList[i] =~ /^\S/ 
      pairs.push([matchDisplay(xList[i]), matchOption(xList[i+1])]) 
    end
  end
  pairs
end

def matchDisplay (dispString)
## Matches a display name
  dispString.match(/^([^\s]*)/)[1]
end

def matchOption (optString)
## Matches a resolution string (since they have whitespace preceding them)
  optString.match(/^\s*([^\s]*)/)[1]
end

def xrandrString (xPairs)
## Takes [[<display name>, <max-resolution>] ...] and returns an xrandr command string
  s = "xrandr --output #{xPairs[0][0]} --mode #{xPairs[0][1]}"
  if xPairs.length >= 2
    (1..xPairs.length-1).to_a.each do |i| # same as above
      s += " --output #{xPairs[i][0]} --mode #{xPairs[i][1]} --right-of #{xPairs[i-1][0]}"
    end
  end
  s
end

exec xrandrString(xrandrPairs(`xrandr`.split("\n")[1..-1]))
