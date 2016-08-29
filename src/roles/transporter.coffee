source = require 'source'
builder = require 'builder'

module.exports =
	
	run: (creep) ->
		
		if source.shouldHarvest(creep)	
			creep.moveTo 22,36
			target = creep.pos.findClosestByPath FIND_SOURCES, {
				filter: (s) => s.energy > 0 
			}			
			if target 				
				creep.harvest target
		else					
			target = Game.getObjectById('57c3b44eaf63961028d02af0')		
			if target
				ret = creep.transfer target, RESOURCE_ENERGY
				if ret is ERR_NOT_IN_RANGE
					creep.moveTo target

			else
				builder.run creep