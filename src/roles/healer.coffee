module.exports = self =

	run: (creep) ->
		target = creep.pos.findClosestByRange FIND_MY_CREEPS, {
			filter: (otherCreep) -> otherCreep.hits < otherCreep.hitsMax
		}
		if target and creep.heal(target) is ERR_NOT_IN_RANGE
				creep.moveTo target				
		else if Game.flags['dFlag']
			target = Game.flags['dFlag']
			creep.moveTo target
