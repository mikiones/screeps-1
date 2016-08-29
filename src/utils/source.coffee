module.exports =

	shouldHarvest: (creep) ->
		creep.memory.lowEnergy = false if creep.carry.energy >= creep.carryCapacity

		if creep.carry.energy < creep.carryCapacity / 10.0
			creep.memory.lowEnergy = true			
		return creep.memory.lowEnergy

	moveToSource: (creep) ->

		targets = creep.room.find FIND_DROPPED_RESOURCES
		if targets.length
			creep.moveTo targets[0]
			creep.pickup targets[0]
			return

		targets = creep.room.find FIND_STRUCTURES, {
			filter: (s) => s.structureType is STRUCTURE_CONTAINER and s.store[RESOURCE_ENERGY] > 0
		}
		if targets.length
			creep.moveTo targets[0]
			creep.withdraw targets[0], RESOURCE_ENERGY
			return

		target = creep.pos.findClosestByPath FIND_SOURCES, {
			filter: (s) => s.energy > 0 
		}			
		if target 
			creep.moveTo target
			creep.harvest target

