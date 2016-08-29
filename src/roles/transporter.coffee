source = require 'source'
builder = require 'builder'

module.exports =
	
	run: (creep) ->
		
		if creep.carry.energy < 50	
			creep.moveTo 22,36
			target = creep.pos.findClosestByPath FIND_SOURCES, {
				filter: (s) => s.energy > 0 
			}			
			if target 				
				creep.harvest target
		else	
			target = creep.pos.findClosestByPath FIND_STRUCTURES, {
				filter: (s) => s.structureType is STRUCTURE_CONTAINER and s.store[RESOURCE_ENERGY] < s.storeCapacity 
			}		
			
			if target			
				ret = creep.transfer target, RESOURCE_ENERGY
				if ret is ERR_NOT_IN_RANGE
					creep.moveTo target
			else
				builder.run creep