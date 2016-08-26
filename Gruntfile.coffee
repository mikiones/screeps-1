module.exports = (grunt) ->

	grunt.initConfig(
		secret: grunt.file.readJSON('secret.json')

		screeps:
			options:
				email: '<%= secret.username %>'
				password: '<%= secret.password %>'

				branch: '<%= secret.branch %>'
				ptr: false
			dist:
				src: ['dist/*.js']
		coffee:
			coffee_to_js:
				options:
					bare: true
					sourceMap: false
				expand: true
				flatten: true
				cwd: "src"
				src: ['**/*.coffee']
				dest: 'dist'
				ext: ".js"
		copy:
			files:
				flatten: true
				expand: true
				cwd: 'node_modules/js-priority-queue'
				src: 'priority-queue.min.js'
				dest: 'dist'
	)

	grunt.loadNpmTasks 'grunt-screeps'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	
	grunt.registerTask 'compileScreeps', ['coffee', 'copy', 'screeps']
	grunt.registerTask 'default', ['compileScreeps']
