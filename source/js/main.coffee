// = require '_jquery.cookie.min'
// = require '_responsiveslides.min'

# Debug, Remove in build
log = (par) ->
	console.log(par)

$(window).load ->

	#      _   _     _           
	#  ___|_|_| |___| |_ ___ ___ 
	# |_ -| | . | -_| . | .'|  _|
	# |___|_|___|___|___|__,|_|  
	#

	page = $('#page')
	page
		.append('<div class="toggleSidebar"><span class="icon">')
		.delegate('.toggleSidebar', 'click', -> 
			toggleSidebar()
			pofoAssign()
	)

	if !$.cookie("sidebar") and $('body').hasClass('portfolio') then page.addClass('sidebar-disabled')
	else if !$.cookie("sidebar") or $.cookie("sidebar") == "enabled" then page.addClass('sidebar-enabled')
	else if $.cookie("sidebar") == "disabled" then page.addClass('sidebar-disabled')

	#	Change the sidebar toggle's graphic depending on it's state
	#	.....

	toggleSidebar = (exceptions) ->

		if $('body.portfolio main').hasClass('featureActive')
			resetTo = $('article.selected').attr('data-index')
			destroyFeature(true)
			setTimeout ->
				pofoAssign()
				$("article[data-index='"+resetTo+"'] a.view").click()
			, 800

		if page.hasClass('sidebar-disabled')
			page
				.removeClass('sidebar-disabled')
				.addClass('sidebar-enabled')
			$.cookie("sidebar", "enabled")

		else if page.hasClass('sidebar-enabled')
			page
				.removeClass('sidebar-enabled')
				.addClass('sidebar-disabled')
			# if $('body').hasClass('portfolio') then return false
			$.cookie("sidebar", "disabled")


	#              _   ___     _ _     
	#  ___ ___ ___| |_|  _|___| |_|___ 
	# | . | . |  _|  _|  _| . | | | . |
	# |  _|___|_| |_| |_| |___|_|_|___|
	# |_|       
	#

	items = $("body.portfolio main").children('article')
	fadetime = 600


	#	Apply '.fade' class to all thumbnails (except current) when mouseover detected
	#	.....

	items.bind
		mouseenter: ->
			items.not(this).each ->
				if $(this).hasClass('selected')
					return false
				$(this).addClass('fade')

			if $('main').hasClass('featureActive') and $(this).hasClass('fade')
				$(this).removeClass('fade')
				# return false

		mouseleave: ->
			items.not(this).each ->
				if $('main').hasClass('featureActive') 
					return false
				else
					$(this).removeClass('fade')

			# if $('main').hasClass('featureActive') and !$(this).hasClass('selected')
			# 	$(this).addClass('fade')


	#	Get each sample item from the portfolio and assign it a row number using HTML5 'data' attribute. 
	#	Re-arrange row assignments if layout width is adjusted or if the sidebar is toggled.
	#	.....

	pofoAssign = ->
		row = 1
		index = 1

		items.each ->
			$(this).attr( "data-index", index )
			index++

			if $(this).prev().length > 0
				if $(this).position().top != $(this).prev().position().top
					row++
				$(this).attr( "data-row", row )

	
	pofoAssign()
	$(window).resize(pofoAssign)


	#	Capture portfolio view link click. Mouseup used to circumvent CSS3 animations interferring with .click()
	#	Create the feature frame below the selected sample's row. 
	#	.....


	$("body.portfolio article a.view").click (e) ->
		if $(this).closest("article").hasClass('selected')
			destroyFeature()
			# return false
		else
			target = $(this).closest('article').data()
			target['href'] = $(this).attr('href')
			designateFeature( target )
		e.preventDefault()

	# ... Destroys Frame from DOM and removes any 'selected' classes

	destroyFeature = (instant) ->

		if instant
			a = 0
		else
			a = 600

		$("article").removeClass('selected')
		$("div.feature").slideUp(a, ->
			$(this).remove()
			$("main").removeClass('featureActive')
		)
		items.removeClass('fade')
		

	# ... Creates the feature frame from inputted target row

	createFeature = (target) ->
		$("article[data-row='"+target.row+"']").last().after("
			<div data-homerow='"+target.row+"' class='feature'>
				<div class='indicator'></div>
				<object class='closeFeature'>
					<svg version='1.1' xmlns='http://www.w3.org/2000/svg'xmlns:xlink='http://www.w3.org/1999/xlink' width='18px' height='18px' viewBox='0 0 18 18' xml:space='preserve'>
						<path d='M10.061,9L18,16.94l-1.057,1.058l-7.941-7.939L1.059,18L0,16.94L7.942,9L0,1.059L1.059,0l7.943,7.941l7.941-7.939L18,1.061 L10.061,9z'/>
					</svg>
				</object>
				<div class='content'>
		")
		$("div.feature").hide().slideDown(600, ->
			$("div.feature .content").load(target.href).hide().fadeIn(fadetime)
		)
		setTimeout ->
			$(this).scrollTop( $(this)[0].scrollHeight )
		, 5000


	# ... Method checks if a feature frame exists and where it is assigned.
	# ... Moves focus of feature if it exists already.
	# ... Handles designation of selected classes and indicator adjustments.

	designateFeature = (target) ->
		homerow = parseInt( $("div.feature").attr('data-homerow') )
		newitem = $("article[data-index='"+target.index+"']")
		position = newitem.position()

		if !homerow
			createFeature(target)

		else if homerow isnt target.row
			destroyFeature()
			createFeature(target)
			newitem.addClass('selected').removeClass('fade')

		else if homerow is target.row

			$("article").removeClass('selected')

			$("div.feature .content").fadeOut(fadetime, ->
				$(this)
					.empty()
					.load(target.href)
					.hide()
					.fadeIn(fadetime)
			)

		newitem.addClass('selected').removeClass('fade')
		items.not(newitem).addClass('fade')
		$("main").addClass('featureActive')
		$(".indicator").css( left : Math.ceil(position.left + newitem.width()/2 - $(".indicator").outerWidth()/2 ) )

	$("#main").delegate('.closeFeature', 'click', -> 
		destroyFeature()
		console.log('butts')
	)