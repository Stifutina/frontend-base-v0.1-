###!=================PROJECT CUSTOM SCRIPT=================###

jQuery(document).ready(->
	'use strict'
	$(this).controllerModule()
	true
)

window.onload = () ->
	$(document).layoutModule()
	true


###!--------MODULES--------###


###!Layout module###
(($) ->
	'use strict'
	variables =
		orientation: if (window.innerHeight > window.innerWidth) then 'vertical' else 'horizontal'
		initialWindowSize: [window.innerHeight, window.innerWidth]
		currentWindowSize: [window.innerHeight, window.innerWidth]

	methods =
		init: (options)->
			$.extend(variables, options, {element: this})
			methods.resizeViewPort()
			this


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
					###! virtual keyboard ###
					this
			true


	$.fn.layoutModule = (method) ->
		if (methods[method])
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1))
		else if (typeof method == 'object' || !method)
			return methods.init.apply(this, arguments);
		else
			$.error('No such method')) jQuery