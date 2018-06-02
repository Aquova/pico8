pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- sine
-- by aquova

t=0
pts={}
cc={x=30,y=64,r=20}
rc={x=0,y=0,r=2}
cols={2,1,12,11,10,9,8}

function _update()
	t+=0.01
	rc.x = cc.x+cc.r*sin(t)
	rc.y = cc.y-cc.r*cos(t)
	col=cols[ceil((cos(t)+1)*3.5)]
	add(pts,{64,rc.y,col})
end

function _draw()
	cls(7)
	line(64,20,64,108,0)
	line(cc.x,cc.y,rc.x,rc.y,6)
	circ(cc.x,cc.y,cc.r,12)
	line(rc.x,rc.y,64,rc.y,6)
	circfill(rc.x,rc.y,rc.r,11)
	for p in all(pts) do
		p[1]+=1
		if p[1] > 64 then
			-- pset(p[1],p[2],8)
			pset(p[1],p[2],p[3])
		elseif p[1] > 128 then
			del(pts,p)
		end
	end
end
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777bbb77777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777bbbbb7777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777ccccccbbbbb6666666666666666666666666666997777777777777777777777777777777777777777777777777777777777777
77777777777777777777777ccc777777bbbbbc777777777777777777777777770779977777777777777777777777777777777777777777777777777777777777
777777777777777777777cc7777777777bbb77cc7777777777777777777777770777799777777777777777777777777777777777777777777777777777777777
7777777777777777777cc7777777777776777777cc77777777777777777777770777777977777777777777777777777777777777777777777777777777777777
777777777777777777c77777777777777677777777c7777777777777777777770777777799777777777777777777777777777777777777777777777777777777
77777777777777777c7777777777777776777777777c777777777777777777770777777777977777777777777777777777777777777777777777777777777777
7777777777777777c777777777777777767777777777c77777777777777777770777777777797777777777777777777777777777777777777777777777777777
777777777777777c77777777777777777677777777777c7777777777777777770777777777779777777777777777777777777777777777777777777777777777
77777777777777c7777777777777777767777777777777c777777777777777770777777777777977777777777777777777777777777777777777777777777777
7777777777777c777777777777777777677777777777777c77777777777777770777777777777797777777777777777777777777777777777777777777777777
7777777777777c777777777777777777677777777777777c77777777777777770777777777777779777777777777777777777777777777777777777777777777
777777777777c77777777777777777776777777777777777c7777777777777770777777777777777977777777777777777777777777777777777777777777777
777777777777c77777777777777777776777777777777777c7777777777777770777777777777777797777777777777777777777777777777777777777777777
77777777777c7777777777777777777677777777777777777c777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777c7777777777777777777677777777777777777c777777777777770777777777777777779777777777777777777777777777777777777777777777
77777777777c7777777777777777777677777777777777777c777777777777770777777777777777777977777777777777777777777777777777777777777777
7777777777c777777777777777777776777777777777777777c77777777777770777777777777777777797777777777777777777777777777777777777777777
7777777777c777777777777777777776777777777777777777c77777777777770777777777777777777779777777777777777777777777777777777777777777
7777777777c777777777777777777767777777777777777777c77777777777770777777777777777777777777777777777777777777777777777777777777777
7777777777c777777777777777777767777777777777777777c77777777777770777777777777777777777977777777777777777777777777777777777777777
7777777777c777777777777777777767777777777777777777c77777777777770777777777777777777777797777777777777777777777777777777777777777
7777777777c777777777777777777777777777777777777777c77777777777770777777777777777777777779777777777777777777777777777777777777777
7777777777c777777777777777777777777777777777777777c77777777777770777777777777777777777777977777777777777777777777777777777777777
7777777777c777777777777777777777777777777777777777c77777777777770777777777777777777777777777777777777777777777777777777777777777
7777777777c777777777777777777777777777777777777777c77777777777770777777777777777777777777797777777777777777777777777777777777777
77777777777c7777777777777777777777777777777777777c777777777777770777777777777777777777777779777777777777777777777777777777777777
77777777777c7777777777777777777777777777777777777c777777777777770777777777777777777777777777977777777777777777777777777777777777
77777777777c7777777777777777777777777777777777777c777777777777770777777777777777777777777777797777777777777777777777777777777777
777777777777c77777777777777777777777777777777777c7777777777777770777777777777777777777777777779777777777777777777777777777777777
777777777777c77777777777777777777777777777777777c7777777777777770777777777777777777777777777777977777777777777777777777777777777
7777777777777c777777777777777777777777777777777c77777777777777770777777777777777777777777777777797777777777777777777777777777777
7777777777777c777777777777777777777777777777777c77777777777777770777777777777777777777777777777777777777777777777777777777777779
77777777777777c7777777777777777777777777777777c777777777777777770777777777777777777777777777777779977777777777777777777777777797
777777777777777c77777777777777777777777777777c7777777777777777770777777777777777777777777777777777797777777777777777777777777977
7777777777777777c777777777777777777777777777c77777777777777777770777777777777777777777777777777777779777777777777777777777779777
77777777777777777c7777777777777777777777777c777777777777777777770777777777777777777777777777777777777977777777777777777777797777
777777777777777777c77777777777777777777777c7777777777777777777770777777777777777777777777777777777777797777777777777777779977777
7777777777777777777cc7777777777777777777cc77777777777777777777770777777777777777777777777777777777777779977777777777777997777777
777777777777777777777cc777777777777777cc7777777777777777777777770777777777777777777777777777777777777777799777777777799777777777
77777777777777777777777ccc777777777ccc777777777777777777777777770777777777777777777777777777777777777777777999999999977777777777
77777777777777777777777777ccccccccc777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777770777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

