source = require 'source'
upgrader = require 'upgrader'

module.exports =
	
	run: (creep) ->
		
		if source.shouldHarvest(creep)

			
			source.moveToSource(creep)		
		else		
			target = creep.pos.findClosestByPath FIND_STRUCTURES, {
					filter: (s) -> return (s.structureType in [STRUCTURE_SPAWN, STRUCTURE_EXTENSION, STRUCTURE_TOWER] and s.energy < s.energyCapacity) 					
				}
			if not target
				upgrader.run creep
			else if creep.transfer(target, RESOURCE_ENERGY) is ERR_NOT_IN_RANGE
				creep.moveTo target				
