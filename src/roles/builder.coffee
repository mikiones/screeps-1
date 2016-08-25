source = require 'source'
module.exports =
	
	run: (creep) ->

		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else
			target = creep.pos.findClosestByPath FIND_CONSTRUCTION_SITES
			if target and creep.build(target) is ERR_NOT_IN_RANGE
				creep.moveTo target					
