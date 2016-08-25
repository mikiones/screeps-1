module.exports =

	shouldHarvest: (creep) ->
		creep.memory.lowEnergy = false if creep.carry.energy >= creep.carryCapacity

		if creep.carry.energy < creep.carryCapacity / 10.0
			creep.memory.lowEnergy = true			
		return creep.memory.lowEnergy

	moveToSource: (creep) ->
		target = creep.pos.findClosestByPath FIND_SOURCES, {
			filter: (s) => s.energy > 0
		}			
		if target and creep.harvest(target) is ERR_NOT_IN_RANGE
			creep.moveTo target