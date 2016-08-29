module.exports =
	
	clear: ->
		for name,creep of Memory.creeps
			if not Game.creeps[name]
				delete Memory.creeps[name]
				console.log 'Clearing non-existing creep memory:', name

	clearConstruction: ->
		for id,cs of Game.constructionSites
			cs.remove()
