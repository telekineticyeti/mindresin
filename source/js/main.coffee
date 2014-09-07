// = require '_jquery.cookie.min'
// = require '_responsiveslides.min'

$(window).load ->

	#      _   _     _           
	#  ___|_|_| |___| |_ ___ ___ 
	# |_ -| | . | -_| . | .'|  _|
	# |___|_|___|___|___|__,|_|  
	#
	page = $('#page')


	#	Add sidebar toggle button to the dom, and delegate any events
	#	applied to it to our custom functions.
	#
	page
		.append('<div class="toggleSidebar"><span class="icon">')
		.delegate('.toggleSidebar', 'click', -> 
			toggleSidebar()
			portfolioDesignateItems()
	)


	#	Use jquery.cookie plugin to keep the sidebar toggle state between sessions.
	#	Portfolio page has sidebar disabled by default
	#
	if !$.cookie("sidebar") and $('body').hasClass('portfolio') then page.addClass('sidebar-disabled')
	else if !$.cookie("sidebar") or $.cookie("sidebar") == "enabled" then page.addClass('sidebar-enabled')
	else if $.cookie("sidebar") == "disabled" then page.addClass('sidebar-disabled')

	#	Function controls behaviour of sidebar, and reacts to different criteria
	#	such as media queries and overlays.
	#
	toggleSidebar = (exceptions) ->

		#	IF current view is the portfolio page, and there is an overlay active
		#	THEN destroy overlay, and rebuild it
		#
		if $('body.portfolio main').hasClass('featureActive')
			resetTo = $('article.selected').attr('data-index')
			destroyFeature(true)
			setTimeout ->
				portfolioDesignateItems()
				$("article[data-index='"+resetTo+"'] a.view").click()
			, 800

		#	IF sidebar is currently disabled
		#	THEN enable sidebar and set cookie.
		#
		if page.hasClass('sidebar-disabled')
			page
				.removeClass('sidebar-disabled')
				.addClass('sidebar-enabled')
			$.cookie("sidebar", "enabled")

		#	IF sidebar is currently enabled
		#	THEN disable sidebar and set cookie.
		#
		else if page.hasClass('sidebar-enabled')
			page
				.removeClass('sidebar-enabled')
				.addClass('sidebar-disabled')
			$.cookie("sidebar", "disabled")


	#              _   ___     _ _     
	#  ___ ___ ___| |_|  _|___| |_|___ 
	# | . | . |  _|  _|  _| . | | | . |
	# |  _|___|_| |_| |_| |___|_|_|___|
	# |_|       
	#

	#	Create an object for all portfolio items
	portfolioItems = $("body.portfolio main").find('article.portfolio-item')

	#	Animation time 
	fadetime = 600

	portfolioItems.bind

		#	Apply .fade to all portfolio items (except current) 
		#	When mouseover event detected
		#
		mouseenter: ->
			portfolioItems.not(this).each ->
				if $(this).hasClass('selected')
					return false
				$(this).addClass('fade')

			if $('main').hasClass('featureActive') and $(this).hasClass('fade')
				$(this).removeClass('fade')

		#	Remove .fade on mouse leave
		#
		mouseleave: -> 
			portfolioItems.not(this).each ->
				if $('main').hasClass('featureActive') 
					return false
				else
					$(this).removeClass('fade')


	#	Designate each portfolio item with a data-index-row attribute.
	#	Item's row is determined by it's 'top' position. If the position is not the same as
	#	the previous item, increment the row integer by 1 and move on.
	#
	portfolioDesignateItems = ->
		row = 1

		portfolioItems.each ->
			if $(this).prev().length > 0
				if $(this).position().top != $(this).prev().position().top
					row++
			$(this).attr( "data-row", row )

	#	Initiate item designation when page loads, and initiate again if the viewport changes.
	#
	portfolioDesignateItems()
	$(window).resize(portfolioDesignateItems)

	#	Handle events on portfolio item's view  button.
	#	Create the feature frame below the selected sample's row. 
	#
	$("body.portfolio article.portfolio-item a.view").click (e) ->
		if $(this).closest("article").hasClass('selected')
			destroyFeature()
			# return false
		else
			target = $(this).closest('article').data()
			target['href'] = $(this).attr('href')
			designateFeature( target )
		e.preventDefault()

	#	Destroys Frame and removes any 'selected' classes
	#
	destroyFeature = (instant) ->
		if instant
			animtime = 0
		else
			animtime = 600

		#	Remove selected class
		#
		$("article").removeClass('selected')

		#	Animate frame height to 0 before destroying.
		#
		$("div.feature").slideUp(animtime, ->
			$(this).remove()
			$("main").removeClass('featureActive')
		)

		#	Remove any lingering fade effects on remaining items
		#
		portfolioItems.removeClass('fade')
		

	#	Creates the feature frame at target row
	#
	createFeature = (target) ->

		#	Find last element of (target) row, and inset following html after it
		#
		$("article[data-row='"+target.row+"']").last().after("
			<div data-homerow='"+target.row+"' class='feature'>
				<div class='indicator'></div>
				<object class='closeFeature'>
					<svg version='1.1' xmlns='http://www.w3.org/2000/svg'xmlns:xlink='http://www.w3.org/1999/xlink' width='18px' height='18px' viewBox='0 0 18 18' xml:space='preserve'>
						<path d='M10.061,9L18,16.94l-1.057,1.058l-7.941-7.939L1.059,18L0,16.94L7.942,9L0,1.059L1.059,0l7.943,7.941l7.941-7.939L18,1.061 L10.061,9z'/>
					</svg>
				</object>
				<div class='feature-content'>
		")

		#	Hide the created feature frame, then slide into view.
		#	Once the target page has been loaded into frame.
		#
		$(".feature").hide()

		$(".feature .feature-content").load(target.href, ->
			$(this).fadeTo(0, 0)
			$(".feature").slideDown(700, ->
				$(".feature .feature-content").fadeTo(700, 1)
			)
		)

		#	Set the page's scroll position to the top of the newly created frame
		#
		setTimeout ->
			$(this).scrollTop( $(this)[0].scrollHeight )
		, 5000


	#	Check if a feature frame exists, and where it is assigned.
	#	Move location of feature frame if it exists already.
	#	Handles designation of selected classes and indicator adjustments.
	#
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

			$("div.feature .feature-content").fadeOut(fadetime, ->
				$(this)
					.empty()
					.load(target.href)
					.hide()
					.fadeIn(fadetime)
			)

		newitem.addClass('selected').removeClass('fade')
		portfolioItems.not(newitem).addClass('fade')
		$("main").addClass('featureActive')
		$(".indicator").css( left : Math.ceil(position.left + newitem.width()/2 - $(".indicator").outerWidth()/2 ) )

	#	Delegate the 'X' on feature frame as a close frame button
	$("#main").delegate('.closeFeature', 'click', -> 
		destroyFeature()
	)