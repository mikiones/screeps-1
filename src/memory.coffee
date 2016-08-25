module.exports =
	
	clear: ->
		for name in Memory.creeps not in Game.creeps
			delete Memory.creeps[name]
			console.log 'Clearing non-existing creep memory:', name