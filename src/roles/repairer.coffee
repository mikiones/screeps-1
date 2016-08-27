source = require 'source'

queue = require('priorityqueue')

values = {}
values[STRUCTURE_WALL] 		= 5
values[STRUCTURE_ROAD] 		= 4
values[STRUCTURE_RAMPART] 	= 3
values[STRUCTURE_EXTENSION] = 2
values[STRUCTURE_SPAWN]		= 1

repairComparer = (a,b) ->	
	aV = values[a.structureType]
	bV = values[b.structureType]
	if aV != bV
		return aV < bV
	
	if a.structureType in [STRUCTURE_ROAD, STRUCTURE_WALL, STRUCTURE_RAMPART]		
		# this will prioritize the weaker structures
		#console.log "a #{a.hits} vs b #{b.hits}"
		return a.hits < b.hits

	return aV < bV

module.exports =
	
	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else	
			targets = creep.room.find FIND_STRUCTURES, { filter: (s) -> return (s.structureType in [STRUCTURE_SPAWN, STRUCTURE_EXTENSION, STRUCTURE_RAMPART, STRUCTURE_WALL] and s.hits < s.hitsMax)}
				
			console.log "#{targets.length} found"
			return if not targets or targets.length == 0

			qTargets = new queue repairComparer
		
			for target in targets
				qTargets.enq target


			target = qTargets.peek()
			console.log target
			#target = creep.pos.findClosestByPath FIND_STRUCTURES, {
			#		filter: (s) -> return (s.structureType is STRUCTURE_ROAD and s.hits < s.hitsMax) or (s.structureType is STRUCTURE_WALL and s.hits < 2000 and s.hits < s.hitsMax) or (s.structureType is STRUCTURE_RAMPART and s.hits < 20000)
			#		}
			if target and creep.repair(target) is ERR_NOT_IN_RANGE
				creep.moveTo target					
