source = require 'source'
module.exports =
	
	run: (creep) ->
		
		if source.shouldHarvest(creep)
			source.moveToSource(creep)		
		else
			target = creep.room.controller
			if target and creep.upgradeController(target) is ERR_NOT_IN_RANGE
				creep.moveTo target		
