memory = require 'memory'
spawner = require 'spawner'
info = require 'info'
towerer = require 'towerer'
roads = require 'roads'
task = require 'task'

roles =
	harvester: require('harvester').run
	upgrader: require('upgrader').run
	builder: require('builder').run
	repairer: require('repairer').run
	defender: require('defender').run
	healer: require('healer').run
	transporter: require('transporter').run

module.exports.loop = ->

	# remove any completed tasks
	task.cleanTasks()

	roads.gatherInfo()

	curRoom = Game.rooms['W58N57']

	if not Memory.task567
		Memory.task567 = true
		newTask = task.createTask()
		newTask.type = 2 # TASK_REPAIR
		newTask.id = '57c359b43035d9d34bc9389e'
		newTask.finishCond = 20000
		task.pushTask newTask


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
		if creep.memory.activeTask			
			task.run creep	
		else
			roles[creep.memory.role]?(creep)

	#towerer.run Game.getObjectById '57bcdc0b4cf378880210e747'