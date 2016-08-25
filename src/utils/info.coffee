module.exports =

	roomEnergy: ->
		for name,room of Game.rooms
			console.log "Available Energy [#{name}]: #{room.energyAvailable} / #{room.energyCapacityAvailable}"

	activeCreep: (types) ->
		for type in types
			members = _.filter Game.creeps, (creep) -> creep.memory.type is type	
			console.log "#{members.length} active #{type}"
