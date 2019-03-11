pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- rally-8
-- @aquova

-- todo
-- enemies affected by smoke
-- enemies spin out when collide
-- high scores
-- music

function _init()
	screen=128
	mapwidth=2*screen
 mapheight=4*screen
 delay=30
	
	turns={u={'r','l'},d={'l','r'},l={'u','d'},r={'d','u'}}

	reset()
end

function reset()
	p1={x=0,
					y=0,
					sx=0,
					sy=0,
					d='u',
					spd=2
				}
				
	cam={x=0,y=0}
	
	lives=2
	level=1
	score=0
	maxflags=10
	
	dust={}
	enemies={}
	scoretags={}
	
	upd=update_title
	drw=draw_title
end

function _update()
	upd()
end

function _draw()
	drw()
end
-->8
-- main game

function update_main()
	frames+=1
	
	if frames<delay then
		return
	elseif trans then
		leveltransition()
		return
	elseif dead then
		if frames>delay then
			death()
		end
		return
	end

	local celx=round(p1.x/8)
	local cely=round(p1.y/8)

	if checkintersection() then
		if btn(⬅️) then
			local m=mget(celx-1,cely)
			if not fget(m,0) then
				p1.d='l'
			end
		elseif btn(➡️) then
			local m=mget(celx+1,cely)
			if not fget(m,0) then
				p1.d='r'
			end
	 elseif btn(⬆️) then
			local m=mget(celx,cely-1)
			if not fget(m,0) then
				p1.d='u'
			end
		elseif btn(⬇️) then
		 local m=mget(celx,cely+1)
		 if not fget(m,0) then
		 	p1.d='d'
		 end
		end
	end
	
	if btn(❎) then
		local newd=createdust()
		add(dust,newd)
	end

	if checkwalls(p1.d) then
		for d in all(turns[p1.d]) do
			if not checkwalls(d) then
				p1.d=d
				return
			end
		end
	end

	checkflags()

	if p1.d=='u' then
		p1.y-=p1.spd
	elseif p1.d=='d' then
		p1.y+=p1.spd
	elseif p1.d=='l' then
		p1.x-=p1.spd
	elseif p1.d=='r' then
		p1.x+=p1.spd
	end

	local m=mget(celx,cely)
	if fget(m,1) then
		die()
	end
	
	-- give player slight headstart
	if frames>delay+15 then
 	for e in all(enemies) do
 		e:update()
 		if e:collide(p1.x,p1.y) then
 			die()
 			break
 		end
 	end
 end
	
	for t in all(scoretags) do
		t:update()
		if t:die() then
			del(scoretags,t)
		end
	end
	
	for d in all(dust) do
		d:update()
		if d:die() then
			del(dust,d)
		end
	end

 if frames%20==0 then
 	fuel-=1
 	if fuel<=0 then
 		death()
 	end
 end
 
 cam.x=p1.x-(screen/2)+4
	cam.y=p1.y-(screen/2)+4
	camera(cam.x,cam.y)
end

function draw_main()
	cls(11) -- outside of map should be green
	map(0,0,0,0,mapwidth/8,mapheight/8)

	for d in all(dust) do
		d:draw()
	end

	for t in all(scoretags) do
		t:draw()
	end
	
	for e in all(enemies) do
		e:draw()
	end

	if dead then
		spr(6,p1.x,p1.y)
	else
 	if (p1.d=='u') then
 		spr(1,p1.x,p1.y)
 	elseif (p1.d=='d') then
 		spr(1,p1.x,p1.y,1,1,false,true)
 	elseif (p1.d=='l') then
 		spr(2,p1.x,p1.y)
 	elseif (p1.d=='r') then
 		spr(2,p1.x,p1.y,1,1,true)
 	end
 end
	
	drawfuel()
	drawbar()
	drawminimap()
end
-->8
-- player functions

function checkintersection()
	-- only return true if at intersection
	local celx=round(p1.x/8)
	local cely=round(p1.y/8)

	return celx*8==p1.x and cely*8==p1.y
end

function checkwalls(d)
 local celx
 local cely
	if d=='u' then
		celx=flr(p1.x/8)
		cely=flr((p1.y-1)/8)
	elseif d=='d' then
  celx=flr(p1.x/8)
		cely=flr((p1.y+1)/8)+1
	elseif d=='l' then
		celx=flr((p1.x-1)/8)
		cely=flr(p1.y/8)
	elseif d=='r' then
		celx=flr((p1.x+1)/8)+1
		cely=flr(p1.y/8)
	end

	local m=mget(celx,cely)
	return fget(m,0)
end

function die()
	frames=0
	dead=true
end

function death()
	lives-=1
	if lives==0 then
		gameover()
	end
	
	-- reset player position
	p1.x=p1.sx
	p1.y=p1.sy
	p1.d='u'
	-- reset fuel level
	fuel=100
	frames=0
	dead=false
	dust={}
	-- reset score multipliers
	flagval=0
	x2=false
	scoretags={}
	-- reset camera
	cam.x=p1.x-(screen/2)+4
	cam.y=p1.y-(screen/2)+4
	camera(cam.x,cam.y)

	-- reset enemies
	for e in all(enemies) do
		e:reset()
	end
end

function gameover()
	reset()
end

function createdust()
	local d={}
	d.x=round(p1.x/8)
	d.y=round(p1.y/8)
	d.age=0
	
	d.update=function(self)
		self.age+=1
	end
	
	d.die=function(self)
		return (self.age>30)
	end
	
	-- checks if {x,y} is in dust
 d.checkdust=function(self)
 	for i in all(dust) do
 		if i.x==d.x and i.y==d.y then
 			return true
 		end
 	end
 	return false
 end

	d.draw=function(self)
		spr(7,self.x*8,self.y*8)
	end
	
	if d.checkdust() then
		return nil
	end

	fuel-=3
	sfx(3)
	return d
end

function checkflags()
	local celx=round(p1.x/8)
	local cely=round(p1.y/8)
	local m=mget(celx,cely)
	if m==3 or m==4 then
	 if (m==4) then
	 	x2=true
	 	sfx(1)
	 else
	 	sfx(0)
	 end
		mset(celx,cely,33)
		removeitem(celx,cely,flags)
		local mult=x2 and 2 or 1
		flagval+=100
		score+=flagval*mult
		local newtag=newscore(celx*8,cely*8,flagval,x2)
		add(scoretags,newtag)
	end

	if #flags==0 then
		trans=true
	end
end
-->8
-- utilities

-- rounds a number up/down
function round(x)
	return flr(x+0.5)
end

-- returns manhattan distance
function dist(x1,y1,x2,y2)
	return abs(x1-x2)+abs(y1-y2)
end

-- calculates x for centering text between x1 and x2
function ctext(t,x1,x2)
	return ((x2-x1)/2)-#t*2
end

-- prints center aligned text
-- takes camera into account
function printc(t,y,c)
	print(t,cam.x+ctext(t,0,screen),cam.y+y,c)
end

-- prints right aligned text
function printr(t,y,c)
	local x=screen-4*#t-1
	print(t,cam.x+x,cam.y+y,c)
end

-- prints text with a border
function printb(t,x,y,cin,cout)
	for i=-1,1 do
		for j=-1,1 do
			print(t,cam.x+(x+i),cam.y+(y+j),cout)
		end
	end

	print(t,cam.x+x,cam.y+y,cin)
end

-- print both centered and w/ border
function printbc(t,y,cin,cout)
	local x=ctext(t,0,screen)
	printb(t,x,y,cin,cout)
end

function finditem(x,y,tbl)
	for i in all(tbl) do
		if i[1]==x and i[2]==y then
			return i
		end
	end

	return nil
end

-- removes from table by xy
function removeitem(x,y,tbl)
	local search=finditem(x,y,tbl)
	del(tbl,search)
end

function floodfill(x,y,arr)
	arr[x][y]=true
	
	local neighbors=getneighbors(x,y)
	for n in all(neighbors) do
		if not arr[n[1]][n[2]] then
			floodfill(n[1],n[2], arr)
		end
	end
end

function contains(val,tbl)
	for v in all(tbl) do
		if v==val then
			return true
		end
	end
	return false
end
-->8
-- enemy functions

function newenemy(x,y)
	local e={x=x,sx=x,y=y,sy=y,d='u',spd=2}
	
	e.update=function(self)
		-- todo: check if collide with rock
		-- only turn if at intersection
		if e:atturn()  then
			local options=turns[e.d]
			add(options,e.d)
			e.d=e:choosebest(options)
		end
		
		if e.d=='u' then 
			e.y-=e.spd
		elseif e.d=='l' then
			e.x-=e.spd
		elseif e.d=='r' then
		 e.x+=e.spd
		elseif e.d=='d' then
			e.y+=e.spd
		end
	end
	
	e.reset=function(self)
		e.x=e.sx
		e.y=e.sy
		e.d='u'
	end
	
	e.atturn=function(self)
		local celx=round(e.x/8)
		local cely=round(e.y/8)
		
		return e.x==celx*8 and e.y==cely*8
	end
	
	e.choosebest=function(self,options)
		local reverse={d='u',u='d',l='r',r='l'}
		local bestdir=nil
		local bestval=9999

	 local celx=round(e.x/8)
	 local cely=round(e.y/8)
	 
	 -- check to see which directions is valid turn
	 -- of those, see which is closest to player
	 for d in all(options) do
	 	local m
	 	local d2p
			if d=='u' then
				m=mget(celx,cely-1)
				d2p=dist(p1.x,p1.y,e.x,e.y-1)
			elseif d=='d' then
				m=mget(celx,cely+1)
				d2p=dist(p1.x,p1.y,e.x,e.y+1)
			elseif d=='l' then
				m=mget(celx-1,cely)
				d2p=dist(p1.x,p1.y,e.x-1,e.y)
			elseif d=='r' then
				m=mget(celx+1,cely)
				d2p=dist(p1.x,p1.y,e.x+1,e.y)
			end
			
			if m==33 then
				if d2p<bestval then
					bestdir=d
					bestval=d2p
				end			
			end
		end
		
		-- if deadend (from rocks), reverse
		if bestdir==nil then
			bestdir=reverse[e.d]
		end
		return bestdir
	end
	
	e.collide=function(self,x,y)
		local celx=round(x/8)
		local cely=round(y/8)
		
		local ecelx=round(e.x/8)
		local ecely=round(e.y/8)
		
		return (celx==ecelx and cely==ecely)
	end
	
	e.draw=function(self)
		pal(12,8)
		if (e.d=='u') then
 		spr(1,e.x,e.y)
 	elseif (e.d=='d') then
 		spr(1,e.x,e.y,1,1,false,true)
 	elseif (e.d=='l') then
 		spr(2,e.x,e.y)
 	elseif (e.d=='r') then
 		spr(2,e.x,e.y,1,1,true)
 	end
		pal()
	end

	return e
end
-->8
-- level functions

function loadlevel()
	frames=0
	flags={}
	scoretags={}
	enemies={}
	fuel=100
	flagval=0
	x2=false
	trans=false
	dead=false

	-- resets map
	reload()	
	
	-- iterate through map, replace special tiles with objects
	for x=0,mapwidth/8 do
		for y=0,mapheight/8 do
			if mget(x,y)==8 then
				--mset(x,y,33)
				p1.sx=8*x
				p1.x=p1.sx
				p1.sy=8*y
				p1.y=p1.sy
				p1.d='u'
			elseif mget(x,y)==9 then
				mset(x,y,33)
				local e=newenemy(8*x,8*y)
				add(enemies,e)
			end
		end
	end
	
	placerocks()
	local flagarray=genflagarray()
	floodfill(p1.sx/8,p1.sy/8, flagarray)
	placeflags(flagarray)
	mset(p1.sx/8,p1.sy/8,33)
	
	cam.x=p1.x-(screen/2)+4
	cam.y=p1.y-(screen/2)+4
	camera(cam.x,cam.y)
end

function placeflags(arr)
	local sflag=1
	local flag=maxflags-1

	-- set s flag
	repeat
		local x=flr(rnd(mapwidth/8))
		local y=flr(rnd(mapheight/8))
		if mget(x,y)==33 and arr[x][y] then
			mset(x,y,4)
			add(flags,{x,y})
			sflag-=1
		end
	until sflag==0

	-- set regular flags
	repeat
		local x=flr(rnd(mapwidth/8))
		local y=flr(rnd(mapheight/8))
		if mget(x,y)==33 and arr[x][y] then
			mset(x,y,3)
			add(flags,{x,y})
			flag-=1
		end
	until flag==0
end

function placerocks()
	local rocks=5

	repeat
		local x=flr(rnd(mapwidth/8))
		local y=flr(rnd(mapheight/8))
		local d=dist(x,p1.sx,y,p1.sy)
		if mget(x,y)==33 and d>5 then
			mset(x,y,5)
			rocks-=1
		end
	until rocks==0
end

function nextlevel()
	level+=1
	loadlevel()
end

function leveltransition()
	-- convert fuel to points, move to next level
	-- todo: add slight pause before and after fuel to points
	if fuel~=0 then
		fuel-=1
		score+=10
		if fuel%3==0 then
			sfx(2)
		end
	else
		nextlevel()
	end
end

-- x and y should be cell values
function getneighbors(x,y)
	local n={}
	
	local dirs={{0,1},{0,-1},{-1,0},{1,0}}
	for i in all(dirs) do
		local ix=mid(1,x+i[1],mapwidth/8)
		local iy=mid(1,y+i[2],mapheight/8)
		
		if (ix~=x) or (iy~=y) then
		 if mget(ix,iy)==33 then
				add(n,{ix,iy})
			end
		end	
	end

	return n
end

function genflagarray()
	local a={}
	
	for x=1,mapwidth/8 do
		local row={}
		for y=1,mapheight/8 do
			add(row,false)
		end
		add(a,row)
	end
	
	return a
end

-->8
-- drawing functions

function drawminimap()
	local mapw=mapwidth/16
	local maph=mapheight/16
	local mapx=cam.x+screen-mapw
	local mapy=cam.y+screen-maph
	rectfill(mapx,mapy,cam.x+screen,cam.y+screen,5)
	-- draw flags
	for f in all(flags) do
		local fx=f[1]/2
		local fy=f[2]/2
		pset(mapx+fx,mapy+fy,10)
	end
	
	-- draw enemies
	for e in all(enemies) do
		local ex=e.x/16
		local ey=e.y/16
		pset(mapx+ex,mapy+ey,8)
	end
	
	-- draw player
	pset(mapx+p1.x/16,mapy+p1.y/16,12)
end

function drawfuel()
	local barwidth=fuel/100*screen/3
	local c=(fuel<20) and 8 or 10
	rectfill(cam.x+screen/3,cam.y+screen-13,cam.x+2*screen/3,cam.y+screen-3,0)
	rectfill(cam.x+screen/3-1,cam.y+screen-12,cam.x+2*screen/3+1,cam.y+screen-4,0)
	if fuel>0 then
 	rectfill(cam.x+screen/3,cam.y+screen-11,cam.x+screen/3+barwidth,cam.y+screen-5,c)
 	if barwidth>1 then
 		rectfill(cam.x+screen/3+1,cam.y+screen-12,cam.x+screen/3+barwidth-1,cam.y+screen-4,c)
 	end
 	if barwidth>2 then
 		pset(cam.x+screen/3+2,cam.y+screen-10,7)
 	end
 	if barwidth>3 then
 		line(cam.x+screen/3+3,cam.y+screen-11,cam.x+screen/3+barwidth,cam.y+screen-11,7)
 	end
 end
	printc("fuel",screen-9,5)
end

function drawbar()
	rectfill(cam.x,cam.y,cam.x+screen,cam.y+9,3)
	printb("round: "..level,2,2,7,0)
	printbc("score: "..score,2,7,0)
	-- should do something else if lives>3
	local x=screen-9
	for i=1,lives do
		spr(1,cam.x+x,cam.y+1)
		x-=10
	end
end

function newscore(x,y,val,mult)
	local s={x=x,y=y,val=val,age=0,x2=mult}
	
	s.update=function(self)
		self.age+=1
	end
	
	s.die=function(self)
		return (self.age>30)
	end
	
	s.draw=function(self)
	 if self.x2 then
			print(val.."x2",self.x-5,self.y+1,0)
		else
			print(val,self.x-1,self.y+1,0)		
		end
	end
	
	return s
end
-->8
-- title screen

function update_title()
	if btnp(❎) or btnp(🅾️) then
		upd=update_main
		drw=draw_main
		loadlevel()
	end
end

function draw_title()
	cls(1)
	printbc("rally-8",screen/2,7,0)
end
__gfx__
00000000050cc05000000555ffaaffffffaaffffffffffff00888800004444005555555555555555555555550000000000000000000000000000000000000000
00000000055cc55055500050ffaaafffffaaaffffff555ff08899880044994405000000550000005500000050000000000000000000000000000000000000000
00700700050cc050050cccccffaaaaffffaaaaffff5fff5f889aa988449ff944500cc00550800805509999050000000000000000000000000000000000000000
0007700000cccc00cccc777cffaaaaafffaaa888f54444f589a77a9849f77f9450c00c0550088005509009050000000000000000000000000000000000000000
0007700000c77c00cccc777cffafffffffaf8fff5444444589a77a9849f77f9450c00c0550088005509009050000000000000000000000000000000000000000
0070070050c77c05050cccccffafffffffaff88f54444445889aa988449ff944500cc00550800805509999050000000000000000000000000000000000000000
0000000055c77c5555500050ffafffffffaffff85444444508899880044994405000000550000005500000050000000000000000000000000000000000000000
0000000050cccc0500000555faaafffffaaa888ff555555f00888800004444005555555555555555555555550000000000000000000000000000000000000000
ffffffffffffffffffffffffbbbbbbbbbbbbbbbbffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000
fff999999999999999999fffbbbbbbbbbbbbbbbbff9999ffff99999999999999999999ff00000000000000000000000000000000000000000000000000000000
ff9bbbbbbbbbbbbbbbbbb9ffbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbbbbbbbbbbbbbbbbb9f00000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbbbbbbbbbbbbbbbbb9f00000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbbbbbbbbbbbbbbbbb9f00000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbbbbbbbbbbbbbbbbb9f00000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9fbbbbbbb99bbbbbbbf9bbbb9fff99999999999999999999ff00000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9fbbbbbb9ff9bbbbbbf9bbbb9fffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbb9ff9bbbbbbf9bbbb9fffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbbb99bbbbbbbf9bbbb9ffff9999999999fff0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9fff9bbbbbbbbbb9ff0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbbbbbbbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbbbbbbbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbbbbbbbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbbb99bbbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbffffffffbbbbbb9fbbbbbbbbbbbbbbbbf9bbbb9ff9bbbb9ff9bbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9fffffffffbbbbbbbbf9bbbb9ff9bbbb9ff9bbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9fff9999ffbbbbbbbbf9bbbb9ff9bbbbb99bbbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9ff9bbbb9fbbbbbbbbf9bbbb9ff9bbbbbbbbbbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9ff9bbbb9fbbbbbbbbf9bbbb9ff9bbbbbbbbbbbb9f0000000000000000000000000000000000000000000000000000000000000000
f9bbbbbbbbbbbbbbbbbbbb9ff9bbbb9fbbbbbbbbf9bbbb9ff9bbbbbbbbbbbb9f0000000000000000000000000000000000000000000000000000000000000000
ff9bbbbbbbbbbbbbbbbbb9fff9bbbb9fbbbbbbbbf9bbbb9fff9bbbbbbbbbb9ff0000000000000000000000000000000000000000000000000000000000000000
fff999999999999999999fffff9999ffbbbbbbbbff9999fffff9999999999fff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffbbbbbbbbffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
43432212521212014243321111211202221252335212521212120222121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
43432212521212034143311313231202221263717312637181120222123312020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31132312637212120231231212121202221212121212121212120222121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121212126381120323121201111142321111211201211201114232112112020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22126172121212121212121203131341311313231202221203131313132312020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121252120111111111211212121202221212121202221212121212121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121252120231131341221201211202221201111142221201111111112112020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121252120232111142221203231203231203131313231203131313132312020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22126173120313131313231212121212121212121212121212121212121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121212121212121212121212011111111121120111111111112112618112020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22120111112112012112012112023113131323120231131313412212121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22120243432212022212022212022212121212120222121212022212012112020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22120243432212022212022212022212617181120222125112022212022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22120313412212022212022212022212121212120323125212032312022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121212022212032312032312023211111121121212125212121212022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
32112112032312121212121212031313134122120121125212012112022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31132312121212011111112112121212120222120222125312022212022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121212012112031313132312617181120222120222121212022212032312020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22120111422212121212121212121212120222120232111111422212121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22120243432212627171717212011111114222120313131313132312618112020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22120313132312637171717312031313131323121212121212121212121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121212121212121212121212121212121212120121121201211201111111420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22125112121233125112511251125112011121120232111142221203131313410000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22125212511212125312521252125212024322120313131313231212121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22125212521251121212531252125212024322121212121212121212012112020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22125212521252125112121253125212024332111111112112012112022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22125312531253125312331212125312024331131313132312022212022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22121212121212121212121212121212024322121212121212022212022212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
32112112121201111111111111112112024322120111111111422212032312020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
43433221121203131313131313132312031323120313131313132312121212020000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
43434332211212121212121212121212121212121212121212121212011111420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
43434343321111111111111111111111111111111111111111111111424343430000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000020000000000000000000001010101010101010100000000000000010001010101010100000000000000000101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1331313131313131313131313131313131143434343434133131313131313114000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212121212121212121212121212121303131313131322121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221101221101221101221101221101221212121212121212110111111122120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221202221202221202221202221202221101221212110122120133131322120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221202221202221202221202221202221202221212120222120222121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221202221202221202221202221202221202311111124222120222110122120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221303221303221303221303221303221303131313131322120222120222120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212121212121212121212121212121212121212121212130322120222120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221332110122116182110122116171717171717171717182121212120222120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212120222121212120222121212121212121212121212110111124222120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2312211024231111111124222110111111111221152110122130313131322120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3422212034133131313114222130311413313221252120222121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3422212034222121212120222121212022212121252120222110111112211024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3422212034222121212120222115212022212617372120222130313132212034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3422212034231221211024222125212022212521212120222121212121212034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1332213031313221213031322125212022212521101124231112211012212034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212121212121212121212135213032213521303131313132212022212034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221101111111111111111122121212121212121212121212121212022212034000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221303131143434133131322116171821161718211617171718213032213014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212121303131322121212121212121212121212121212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212121212121212121152115211521152115211521101111111111122120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221101111111111122121252125212521252125212521201331313131322120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221303114341331322121252125212521252125212521202221212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212120342221212121252125212508252125212521202221101111122120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221152120342221101221252125212521252125212521202221201331322120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221352120342221303221252125212521252125212521202221202221212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212120342221212121252125212521252125212521303221303221332120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221101124342311122121352135213521352135213521212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221303131313131322121210921212109212121092121161821161717182120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2221212121212121212121161717171717171717171821212121212121212120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2312212121261821101221212121212121212121212121211011111111122120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3423122126372121202312212121211012212617272115213031141331322120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0004000024050240501e0501e05024050240502e0502e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000024050240501e0501e05024050240502e0502e0503a0503a05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002305023050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000266501c65016650116500d6500c6500a6500865007650076500b600086000760007600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
