###!=======MAIN CUSTOM SCRIPT=====###
'use strict'

window.onload = () ->
	###! call jQuery methods for layout effects ###
	$(document).layoutModule()
	true

loadJS = (src, cb)->
	ref = window.document.getElementsByTagName("script")[0]
	script = window.document.createElement "script"
	script.src = src
	script.async = true
	ref.parentNode.insertBefore script, ref
	if (cb && typeof(cb) == "function")
		script.onload = cb
	script

###!--------MODULES--------###


###!Layout module###
(($) ->
	'use strict'
	variables =
		propertyName: "value"
		system: undefined
		noAnimations: false
		orientation: if (window.innerHeight > window.innerWidth) then 'vertical' else 'horizontal'
		initialWindowSize: [window.innerHeight, window.innerWidth]
		currentWindowSize: [window.innerHeight, window.innerWidth]

	methods =
		init: (options)->
			$.extend(variables, options, {element: this})
			$('html,body').scrollTop(0)
			methods.checkIsNoAnimations()
			methods.resizeViewPort()
			methods.windowScroll()
			this


		###!
		checkIsNoAnimations method
		###
		checkIsNoAnimations: () ->
			if (variables.currentWindowSize[1] <= 768 || variables.orientation == 'vertical' || !(Modernizr.cssanimations) || !(Modernizr.csstransitions))
				variables.noAnimations = true
			true

		resizeViewPort: ()->
			$(window).resize ->
				variables.currentWindowSize = [window.innerHeight, window.innerWidth]
				if (window.innerHeight > window.innerWidth)
					variables.orientation = 'vertical'
				else
					variables.orientation = 'horizontal'

				true
			if (Modernizr.touch)
				$('input, textarea').focus ->
					###!
					  virtual keyboard
					  ###
					this
			console.log(variables.currentWindowSize)
			console.log(cssua.ua)
			true

		windowScroll: () ->
			$(document).scroll () ->
				scrollTopPosition = $(this).scrollTop()
			return

	$.fn.layoutModule = (method) ->
		if (methods[method])
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1))
		else if (typeof method == 'object' || !method)
			return methods.init.apply(this, arguments);
		else
			$.error('No such method')) jQuery
