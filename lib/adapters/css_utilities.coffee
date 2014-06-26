module?.exports =
  addClassName: (className, target) ->
    classes = target.className.split(' ')

    if classes.indexOf(className) == -1
      classes.push(className)

    target.className = @validClasses(classes).join(' ')

  removeClassName: (className, target) ->
    classes = target.className.split(' ')
    idx = classes.indexOf(className)

    while (idx != -1)
      delete classes[idx];
      idx = classes.indexOf(className)

    target.className = @validClasses(classes).join(' ')

  validClasses: (classes) ->
    validClasses = []

    for className in classes
      if (className)
        validClasses.push(className)

    validClasses
