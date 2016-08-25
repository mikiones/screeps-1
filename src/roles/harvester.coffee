source = require 'source'
module.exports =
	
	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else		
			target = creep.pos.findClosestByPath FIND_STRUCTURES, {
					filter: (s) -> return (s.structureType in [STRUCTURE_SPAWN, STRUCTURE_EXTENSION, STRUCTURE_TOWER] and s.energy < s.energyCapacity) 
					
				}
			if target and creep.transfer(target, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
				creep.moveTo target	
			else
				creep.moveTo 23, 10
