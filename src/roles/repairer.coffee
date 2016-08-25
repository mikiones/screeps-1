source = require 'source'
module.exports =
	
	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else
			target = creep.pos.findClosestByPath FIND_STRUCTURES, {
					filter: (s) -> return (s.structureType is STRUCTURE_ROAD and s.hits < s.hitsMax) or (s.structureType is STRUCTURE_WALL and s.hits < 200000)
				}
			if target and creep.repair(target) is ERR_NOT_IN_RANGE
				creep.moveTo target					
