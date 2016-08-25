source = require 'source'
module.exports =
	
	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else
			target = creep.pos.findClosestByPath FIND_STRUCTURES, {
					filter: (s) -> return s.structureType in [STRUCTURE_ROAD, STRUCTURE_WALL] and s.energy < s.energyCapacity
				}
			if target and creep.repair(target) is ERR_NOT_IN_RANGE
				creep.moveTo target					
