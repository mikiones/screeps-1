TASK_BUILD = 	1
TASK_REPAIR = 	2

module.exports = self = 

	initialize: () ->	

		# stores pending tasks that are order by most important to least
		Memory.pendingTaskQueue = []

		# stores tasks that have been assigned
		Memory.activeTaskQueue = []

	cleanTasks: () ->
		self.initialize() if not Memory.pendingTaskQueue	

		# clean up active tasks in case of creep death
		newActiveTasks = []
		for activeTask in Memory.activeTaskQueue	
			continue if activeTask.completed
			creep = Game.getObjectById(activeTask.creepId)
			if not creep
				activeTask.active = false
				continue
			newActiveTasks.push activeTask

		Memory.activeTaskQueue = newActiveTasks

		# clean up pending tasks
		newPendingTasks = []
		for task in Memory.pendingTaskQueue
			if not task.completed
				newPendingTasks.push task

		Memory.pendingTaskQueue = newPendingTasks

	createTask: () ->
		task = 
			prio: 1
			id: null
			type: null
			finishCond: null
			completed: false
			active: false

		return task

	pushTask: (task) ->	 	
		console.log "Adding task: #{task}"
		Memory.pendingTaskQueue.push (task)
		Memory.pendingTaskQueue.sort (taskA,taskB) ->	
			return taskA.prio - taskB.prio			

	run: (creep) ->
		task = creep.memory.activeTask
		return if not task

		completed = false

		switch task.type
			when TASK_REPAIR
				creep.say "Repair Task"
				target = Game.getObjectById(task.id)
				ret = require('repairer').repair creep, target
				if ret
					if not task.finishCond or target.hits > task.finishCond
						completed = true

		if completed
			creep.memory.activeTask = null
			task.completed = true			

	assignTask: (task, creep) ->
		console.log "=============Matched #{creep} to #{task}================"
		creep.memory.activeTask = task
		task.active = true
		task.creepId = creep.id
		Memory.activeTaskQueue.push task

	matchTasks: (creeps) ->	
		return if Memory.pendingTaskQueue.length == 0
		console.log "Pending tasks length: #{Memory.pendingTaskQueue.length}"

		for task in Memory.pendingTaskQueue		
			continue if task.active or task.completed
			for name,creep of creeps				
				continue if creep.memory.activeTask
				if creep.memory.role is 'repairer'
					self.assignTask task, creep
					break
					



