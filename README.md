# Tennis For Fans

## DESCRIPTION

## WORKFOW

Update files in source/ and test in browser  
$ git push origin `git branch | grep '*' | cut -b 3-`  
$ middleman build  
$ cd build  
$ git ci --interactive  
$ git push origin `git branch | grep '*' | cut -b 3-`

## TODO

Create bar chart for overall win/lose (win on bottom, lose on top)  
Collect data from wikipedia  
Include two or more players in one diagram  
For top 4 players only

Move bars to middle when player 2 or 3 has no data for that year

## NOTES

* Run server with local data  
LOCAL_DATA=true middleman server
