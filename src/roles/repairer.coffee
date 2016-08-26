source = require 'source'

queue = require('priority-queue.min')

values = {}
values[STRUCTURE_ROAD] 		= 5
values[STRUCTURE_WALL] 		= 4
values[STRUCTURE_RAMPART] 	= 3
values[STRUCTURE_EXTENSION] = 2
values[STRUCTURE_SPAWN]		= 1

repairComparer = (a,b) ->
	aV = values[a.structureType]
	bV = values[b.structureType]
	if av != bV
		return aV < bV
	# todo: handle equal case
	return aV < bV

module.exports =
	
	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else	
			targets = creep.room.find FIND_MY_STRUCTURES, {
			 	filter: (s) -> return s.structureType in [STRUCTURE_SPAWN, STRUCTURE_EXTENSION, STRUCTURE_RAMPART] and s.hits < s.hitsMax
				}	

			qTargets = new queue { 
			 	comparator: repairComparer
			 	initialValues: targets
				}

			target = qTargets.peek()
			console.log target
			#target = creep.pos.findClosestByPath FIND_STRUCTURES, {
			#		filter: (s) -> return (s.structureType is STRUCTURE_ROAD and s.hits < s.hitsMax) or (s.structureType is STRUCTURE_WALL and s.hits < 2000 and s.hits < s.hitsMax) or (s.structureType is STRUCTURE_RAMPART and s.hits < 20000)
			#		}
			if target and creep.repair(target) is ERR_NOT_IN_RANGE
				creep.moveTo target					
