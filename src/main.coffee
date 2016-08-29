memory = require 'memory'
spawner = require 'spawner'
info = require 'info'
towerer = require 'towerer'
roads = require 'roads'
task = require 'task'
repairer = require 'repairer'

roles =
	harvester: require('harvester').run
	upgrader: require('upgrader').run
	builder: require('builder').run
	repairer: repairer.run
	defender: require('defender').run
	healer: require('healer').run
	transporter: require('transporter').run

module.exports.loop = ->

	# remove any completed tasks
	task.cleanTasks()

	roads.gatherInfo()

	curRoom = Game.rooms['W58N57']

	repairer.weakestWall curRoom

	optimalRoad = roads.getOptimalRoadPlacement curRoom

	if optimalRoad and optimalRoad.value > 40
		curRoom.createConstructionSite optimalRoad.x, optimalRoad.y, STRUCTURE_ROAD

	info.roomEnergy()
	info.activeCreep ['harvester','upgrader','builder','repairer', 'defender', 'healer', 'transporter']
	memory.clear()
	
	spawner.setMax 18

	spawner.evaluateSpawn()	

	task.matchTasks Game.creeps

	for name,creep of Game.creeps		
		if creep.memory.activeTaskID			
			task.run creep	
		else
			roles[creep.memory.role]?(creep)

	#towerer.run Game.getObjectById '57bcdc0b4cf378880210e747'