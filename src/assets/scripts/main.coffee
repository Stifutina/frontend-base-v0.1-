###!=================PROJECT CUSTOM SCRIPT=================###


(createLoader = () ->
	loaderElem = document.createElement('div')
	loaderContainer = document.createElement('div')
	loaderStyleElem = document.createElement('style')
	loaderCss = '.loader{display: block; width: 100%; height: 100%; position: fixed; top: 0px; left: 0px; z-index: 99999; background: none repeat scroll 0% 0% #DEEAF6}
                 .loader-container{position:relative;display:block;width:120px;height:120px;}
                 .content-progress-loading{height: 100%;overflow: hidden;position: absolute;top: 0;width: 100%}'

	not_ie = loaderElem.classList
	if (not_ie)
		loaderElem.classList.add('loader')
	else
		loaderElem.className += ' loader'
	loaderElem.appendChild(loaderContainer)
	if (not_ie)
		loaderContainer.classList.add('loader-container')
	else
		loaderContainer.className += ' loader-container'
	loaderStyleElem.type = 'text/css'
	if (loaderStyleElem.stylesheet)
		loaderStyleElem.styleSheet.cssText = loaderCss
	else
		loaderStyleElem.appendChild(document.createTextNode(loaderCss))
	head = document.head || document.getElementsByTagName('head')[0]
	head.appendChild(loaderStyleElem)

	loaderContainer.style.left = ((window.innerWidth - 120) / 2) + 'px'
	loaderContainer.style.top = ((window.innerHeight - 120) / 2) + 'px'

	#!loader on Raphael >>
	paper = Raphael(loaderContainer, 0, 0, 120, 120)
	paper.setSize(120, 120)
	st = paper.set()
	angle = 0
	while (angle < 360)
		st.push(paper.circle(60, 60,
		  1)
		.attr({fill: "black", stroke: 'none', opacity: 0.2, r: 3})
		.animate({
			  cx: 60 + (50 * Math.cos(angle * Math.PI / 180)),
			  cy: 60 + (50 * Math.sin(angle * Math.PI / 180)),
			  r: 10,
			  fill: '#15A6D5'
		  }, 500, 'backIn'))
		angle += 30
	spin = undefined
	st.forEach((el) ->
		spin = Raphael.animation({
			"0%": {opacity: 0.2, r: 3},
			"50%": {opacity: 0.75, r: 10},
			"100%": {opacity: 0.2, r: 3}
		}, 1200, '>').repeat(Infinity)

		time = setTimeout(->
			el.attr({opacity: 0.2, r: 3}).animate(spin)
			return
		, (el.id + 1) * 100)
		return
	)
	#! << loader on Raphael


	bodyElem = document.getElementsByTagName('BODY')[0]
	if (not_ie)
		bodyElem.classList.add('content-progress-loading')
	else
		bodyElem.className += ' content-progress-loading'
	bodyFirstChild = bodyElem.firstElementChild
	bodyElem.insertBefore(loaderElem, bodyFirstChild)
	loaderElem
)()

removeLoader = () ->
	bodyElem = document.getElementsByTagName('BODY')[0]
	loaderElem = bodyElem.getElementsByClassName('loader')[0]
	if (loaderElem != undefined)
		bodyElem.removeChild(loaderElem)
		bodyElem.style = ''
	if (bodyElem.classList)
		bodyElem.classList.remove('content-progress-loading')
	else
		bodyElem.className = bodyElem.className.replace('content-progress-loading', '')
	true

jQuery(document).ready(->
	'use strict'
	$(this).controllerModule()
	true
)

window.onload = () ->
	$(document).layoutModule()
	removeLoader()
	true


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

###!Controller module###
(($) ->
	'use strict'
	variables =
		variable1: true

	methods =
		init: (options)->
			$.extend(variables, options, {element: this})
			this


	$.fn.controllerModule = (method) ->
		if (methods[method])
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1))
		else if (typeof method == 'object' || !method)
			return methods.init.apply(this, arguments);
		else
			$.error('No such method')) jQuery