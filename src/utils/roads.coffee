width = 50
height = 50


module.exports = self =	

	initialize: (room) ->
		console.log "Initializing map for room #{room.name}"
		map = new Array(width)
		for x in [0...width]
			map[x] = new Array(height)
			for y in [0...height]
				structure = (_.filter(room.lookAt(x,y), (obj) -> obj.type is 'terrain' and obj.terrain is 'wall'))	
				if (not structure or structure.length == 0)
					map[x][y] = {
						visits:0, 
						lastVisited: Game.time
					}
		room.memory.map = map

	gatherInfo: ->
		for name,creep of Game.creeps		
			room = creep.room
			if not room.memory.map
				self.initialize(room) 				
			map = room.memory.map
			if not creep.memory.lastPos or creep.memory.lastPos.x != creep.pos.x or creep.memory.lastPos.y != creep.pos.y 
				data = map[creep.pos.x][creep.pos.y]			
				data.visits++
				data.lastVisited = Game.time
			creep.memory.lastPos = {x: creep.pos.x, y: creep.pos.y}
		

	getOptimalRoadPlacement: (room) ->
		map = room.memory.map
		if not map 
			return
		maxVisits = 0
		maxX = 0
		maxY = 0
				
		for x in [0...width]
			for y in [0...height]		
				data = map[x][y]	
				
				continue if not data 

				if data.visits > 0 and data.visits > maxVisits 					
					structure = (_.filter(room.lookAt(x,y), (obj) -> obj.type in ['structure','constructionSite']))	
					if (not structure or structure.length == 0)
						maxVisits = data.visits
						maxX = x
						maxY = y

				# decay if the last visited time is over some specified value
				if data.visits > 0 and Game.time - data.lastVisited	> 500
					console.log 'decaying visits'
					data.visits--
		console.log "Need road at #{maxX},#{maxY} it was visited #{maxVisits} times"
		return {x: maxX, y: maxY, value: maxVisits}