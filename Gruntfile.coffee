module.exports = (grunt) ->

	grunt.initConfig(
		secret: grunt.file.readJSON('secret.json')

		clean: ['dist/*']

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
				cwd: 'node_modules/priorityqueuejs'
				src: 'index.js'
				dest: 'dist'
				rename: (dest,src) ->
					return dest + "/priorityqueue.js"
	)

	grunt.loadNpmTasks 'grunt-screeps'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	
	grunt.registerTask 'compileScreeps', ['clean', 'coffee', 'copy', 'screeps']
	grunt.registerTask 'default', ['compileScreeps']
