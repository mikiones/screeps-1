module.exports = (grunt) ->

	grunt.initConfig(
		secret: grunt.file.readJSON('secret.json')

		screeps: 
			options:
				email: 'dbaileychess@gmail.com'
				password: '<%= secret.password %>'
				branch: 'default'
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
	)

	grunt.loadNpmTasks 'grunt-screeps'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.registerTask 'compileScreeps', ['coffee', 'screeps']
	grunt.registerTask 'default', ['compileScreeps']
