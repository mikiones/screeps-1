source = require 'source'
harvester = require 'harvester'

baseprio = {}
baseprio[STRUCTURE_ROAD] 		= 500
baseprio[STRUCTURE_WALL] 		= 200
baseprio[STRUCTURE_RAMPART] 	= 300
baseprio[STRUCTURE_EXTENSION]	= 200
baseprio[STRUCTURE_SPAWN]		= 100
baseprio[STRUCTURE_CONTAINER]   = 100

module.exports = self =
	

	analyze: (room) ->
		room.memory.buildTick = Game.time

		targets = room.find FIND_CONSTRUCTION_SITES, { 
			filter: (s) -> return s.structureType in [STRUCTURE_ROAD, STRUCTURE_SPAWN, STRUCTURE_EXTENSION, STRUCTURE_RAMPART, STRUCTURE_WALL, STRUCTURE_CONTAINER] 
			}

		if not targets or targets.length == 0
			room.memory.buildTick = null
			return false

		for target in targets
			prio = baseprio[target.structureType]
			# switch target.structureType
			# 	when STRUCTURE_WALL
			# 		if targets.hits == 1
			# 			prio = 100000000000
			# 		if targets.hits < 5000
			# 			prio -= 200
			# 		else if targets.hits < 10000
			# 			prio -= 100
			# 		prio += 100.0 * (target.hits / target.hitsMax)
			# 	when STRUCTURE_ROAD
			# 		prio += 100.0 * (target.hits / target.hitsMax)
			# 	when STRUCTURE_RAMPART
			# 		if target.hits is 1
			# 			prio = -1000
			# 		else
			# 			prio += 100.0 * (target.hits / target.hitsMax)
			# 	else
			# 		prio = 100000000000000		
			target.buildPrio = prio

		targets.sort (a,b) ->	
			return a.buildPrio - b.buildPrio

		room.memory.buildTargets = targets

	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else
			if not creep.room.memory.buildTick or creep.room.memory.buildTick != Game.time
				self.analyze(creep.room)

			targets = creep.room.memory.buildTargets

			return if not targets or targets.length <= 0

			pos = creep.pos

			myBuild = []
			for target in targets
				target.myBuildPrio = target.buildPrio #+ (pos.getRangeTo(target))
				myBuild.push target

			myBuild.sort (a,b) ->	
				return a.myBuildPrio - b.myBuildPrio
					
			target = myBuild[0]
			console.log "Building: #{target}"

			if target 
				if creep.build(target) is ERR_NOT_IN_RANGE
					creep.moveTo target					
			else
				harvester.run creep

