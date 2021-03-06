source = require 'source'
repairer = require 'repairer'
module.exports =
	
	run: (creep) ->
		if source.shouldHarvest(creep)			
			source.moveToSource(creep)		
		else
			target = creep.room.controller
			if target and creep.upgradeController(target) is ERR_NOT_IN_RANGE
				err = creep.moveTo target		
				if err == ERR_NO_PATH
					repairer.run creep