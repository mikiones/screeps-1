source = require 'source'
task = require 'task'

baseprio = {}
baseprio[STRUCTURE_WALL] 		= 500
baseprio[STRUCTURE_ROAD] 		= 400
baseprio[STRUCTURE_RAMPART] 	= 300
baseprio[STRUCTURE_EXTENSION]	= 200
baseprio[STRUCTURE_CONTAINER]	= 200
baseprio[STRUCTURE_SPAWN]		= 100

module.exports = self =
	
	analyze: (room) ->
		room.memory.repairTick = Game.time

		targets = room.find FIND_STRUCTURES, { 
			filter: (s) -> return (s.structureType in [STRUCTURE_ROAD, STRUCTURE_SPAWN, STRUCTURE_EXTENSION, STRUCTURE_RAMPART, STRUCTURE_CONTAINER] and s.hits < s.hitsMax) or s.structureType is STRUCTURE_WALL and s.hits < 200000
			}

		if not targets or targets.length == 0
			room.memory.repairTargets = null
			return false

		for target in targets
			prio = baseprio[target.structureType]
			switch target.structureType
				when STRUCTURE_WALL
					# if targets.hits == 1
					# 	prio = 100000000000
					if targets.hits < 5000
						prio -= 200
					else if targets.hits < 10000
						prio -= 100
					prio += 100.0 * (target.hits / target.hitsMax)
				when STRUCTURE_ROAD
					prio += 100.0 * (target.hits / target.hitsMax)
				when STRUCTURE_RAMPART
					if target.hits is 1
						prio = -1000
					else
						prio += 100.0 * (target.hits / target.hitsMax)
				when STRUCTURE_CONTAINER
					prio -= 50
				else
					prio = 100000000000000		
			target.repairPrio = prio

		targets.sort (a,b) ->	
			return a.repairPrio - b.repairPrio

		room.memory.repairTargets = targets

		#self.weakestWall room

	weakestWall: (room) ->
		# find all walls that aren't 100%
		targets = room.find FIND_STRUCTURES, { 
			filter: (s) -> return s.structureType is STRUCTURE_WALL and s.hits < s.hitsMax
		}

		# sort by hits
		targets.sort (a,b) ->
			return a.hits - b.hits

		# find the weakest one
		target = targets[0]

		if Memory.weakestWallId and Memory.weakestWallId is target.id
			return
		
		newTask = task.createTask()
		newTask.type = 2#TASK_REPAIR
		newTask.targetid = target.id
		newTask.finishCond = target.hits * 1.34 # double the wall hit points
		task.pushTask newTask
		Memory.weakestWallId = target.id
			


	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else	
			if not creep.room.memory.repairTick or creep.room.memory.repairTick != Game.time
				self.analyze(creep.room)

			targets = creep.room.memory.repairTargets

			return if not targets or targets.length <= 0

			pos = creep.pos

			myRepair = []
			for target in targets
				target.myRepairPrio = target.repairPrio * (pos.getRangeTo(target) + 1) / 5 
				myRepair.push target

			myRepair.sort (a,b) ->	
				return a.myRepairPrio - b.myRepairPrio
					
			target = myRepair[0]
			console.log "Reparing: #{target}"

			if target and creep.repair(target) is ERR_NOT_IN_RANGE
				creep.moveTo target					

	repair: (creep, target, finishFunc) ->
		return false if not target 

		if source.shouldHarvest(creep)
			source.moveToSource(creep)
		else
			ret = creep.repair target

			switch ret
				when OK
					return true		
				when ERR_NOT_IN_RANGE
					creep.moveTo target			

			return false
						