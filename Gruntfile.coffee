module.exports = (grunt) ->
  gruntTasks = require('matchdep').filterDev 'grunt-*'
  grunt.loadNpmTasks(task) for task in gruntTasks

  AWS = grunt.file.readJSON('./config/aws-config.json')

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    browserify:
      compile:
        files:
          'build/das.js': ['tmp/src/scripts/das.js']
    coffee:
      compile:
        expand: true
        cwd: 'lib'
        src: ['**/*.coffee']
        dest: 'tmp/src/scripts'
        ext: ".js"
    mochaTest:
      acceptance:
        options:
          reporter: 'spec'
          require: ['coffee-script', './spec/acceptance_helper.coffee']
        src: ['spec/acceptance/**/*.coffee']
      unit:
        options:
          reporter: 'spec'
          require: ['coffee-script', './spec/spec_helper.coffee']
        src: ['spec/unit/**/*.coffee']
    uglify:
      build:
        files:
          'build/das.min.js': ['build/das.js']
    s3:
      options:
        # debug: true
        key: AWS.AWSAccessKeyId
        secret: AWS.AWSSecretKey
        bucket: AWS.bucket
        access: AWS.access
      dev:
        upload: [{
          src: 'build/*.js'
          dest: 'libs/das/v1/'
          gzip: true
        }]

  grunt.registerTask 'test:integration', ['mochaTest:integration']
  grunt.registerTask 'test:unit', ['mochaTest:unit']
  grunt.registerTask 'test', ['mochaTest']

  grunt.registerTask 'build', ['coffee', 'browserify', 'uglify']
  grunt.registerTask 'deploy:production', ['test', 'build', 's3']
  grunt.registerTask 'default', ['test', 'build']
