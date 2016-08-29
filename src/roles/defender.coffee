module.exports = self =

	run: (creep) ->
		target = creep.pos.findClosestByRange FIND_HOSTILE_CREEPS
		if target and creep.attack(target) is ERR_NOT_IN_RANGE
				creep.moveTo target				
		else if Game.flags['dFlag']
			target = Game.flags['dFlag']
			creep.moveTo target

