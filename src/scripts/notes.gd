"""
growth:
	plant value is plant type * constant

decay:
	every x ticks, decay by % or constant or based on plant type

stocks:
	start 40 up / 20 no / 40 down
	every change adds to no
	update every 10 ticks
	held in array[4] - cost, up, no, down

storage:
	unlocked after stocks
	greyed out when 0 - change opacity or show transparent rect

"""
