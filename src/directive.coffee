angular.module('nv.ui.jsonexplorer', [])
.directive 'jsonExplorer', ->
	restrict: 'EA'
	scope:
		jsonData: '=jsonData'
	template: '<div class="nv-ui-json-explorer"></div>'
	link: (scope, elem, attrs)->
		mainContainer = elem.find 'div'

		# references. Keeps track of all objects, to check for circular refs.
		references = []

		# figure out how many properties are in an object
		countProperties = (data)->
			count = 0
			for key of data
				count++

			count

		###
		Show a +/- symbol which lets user expand and collapse
		the object
		###
		createCollapseButton = ->
			collapser = angular.element document.createElement 'span'
			collapser.addClass('collapser').text '+'
			collapser.on 'click', (evt)->
				isPlus = evt.target.innerText is '+'
				evt.target.innerText = if isPlus then '-' else '+'

				collapsible = angular.element(evt.target.parentNode.querySelector 'ul.collapsible')
				ellipsisElems = evt.target.parentNode.querySelectorAll '.ellipsis'
				ellipsis = angular.element ellipsisElems[ellipsisElems.length-1]

				if isPlus
					collapsible.removeClass 'hide'
					ellipsis.addClass 'hide'
				else
					collapsible.addClass 'hide'
					ellipsis.removeClass 'hide'

			collapser

		createEllipsis = (liElem)->
			angular.element(liElem.find('ul')[0]).addClass 'hide'
			angular.element(liElem.find('ul')[0]).after "<span class='ellipsis'>...</span>"


		###
		Recursively process a JSON object.
		Renders a DOM structure that looks nice to the user
		###
		processData = (data,container)->
			if data instanceof Array   # handle arrays
				container.append '['

				if data.length > 0
					ul = angular.element document.createElement 'ul'
					ul.addClass 'array collapsible'

					for val,index in data
						li = angular.element document.createElement 'li'
						isObject = angular.isObject val

						if isObject
							li.append createCollapseButton()

						li.append "#{index}: &nbsp;"
						processData val, li

						if isObject
							createEllipsis li

						if index < (data.length - 1)
							li.append ','

						ul.append li

					container.append ul

				container.append ']'

			else if data instanceof Object   # handle objects
				numProps = countProperties data
				isEmpty = numProps is 0

				container.append '{'

				if not isEmpty
					ul = angular.element document.createElement 'ul'
					ul.addClass 'obj collapsible'

					index = 0
					for key,val of data
						li = angular.element document.createElement 'li'
						isObject = angular.isObject val

						if isObject
							li.append createCollapseButton()


						li.append "<span class='prop'>#{key}</span>"
						li.append ': &nbsp;'

						if isObject
							if val not in references
								references.push val
								processData val, li
							else
								# Show message saying there is a circle ref.
								li.append ' #Circular Reference'
						else
							processData val, li


						if isObject
							createEllipsis li

						index++
						if index < numProps
							li.append ','

						ul.append li

					container.append ul

				container.append '}'

			# Handle primitives
			else if typeof data is 'number'
				container.append "<span class='num'>#{data}</span>"
			else if typeof data is 'string'
				container.append "<span class='string'>\"#{data}\"</span>"
			else if typeof data is 'boolean'
				container.append "<span class='bool'>#{data}</span>"
			else if not data?
				container.append "<span class='null'>null</span>"

		scope.$watch 'jsonData', (newData)->
			mainContainer.empty()
			references = []
			processData newData, mainContainer

