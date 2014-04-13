app = angular.module 'demo', ['uto.flexbox']

app.directive 'flexbox', (flexboxConfigService) ->
	restrict: 'E'
	link: (scope, elm, attrs) ->
		elm.bind 'click', (e) ->
			if elm[0] is e.target or elm[0] is e.srcElement or elm[0] is e.toElement
				console.log "click", elm[0]
				flexboxConfigService.open(elm,attrs)
				scope.$apply()

app.directive 'flexboxConfig', (flexboxConfigService) ->
	restrict: 'E'
	template: "<form name='formi' class='flexbox-config'>
		<label>Columns: </label><input ng-model='form.form.column' type='checkbox'/><br />
		<label>Flex : </label><input ng-model='form.form.flex' type='number'/><br />
		<label>Text-align:</label> 
			<select ng-model='form.form.justify'>
				<option value='start'>Start</option>
				<option value='end'>End</option>
				<option value='center'>Center</option>
			</select><br />
		<label>Align-items:</label> 
			<select ng-model='form.form.align'>
				<option value=''></option>
				<option value='start'>Start</option>
				<option value='end'>End</option>
				<option value='center'>Center</option>
				<option value='stretch'>Stretch</option>
			</select><br />
		<label>Self-align:</label> 
			<select ng-model='form.form.self'>
				<option value='start'>Start</option>
				<option value='end'>End</option>
				<option value='center'>Center</option>
				<option value='stretch'>Stretch</option>
			</select><br />
			<button ng-click='form.close()'>Close</button>
			<button ng-click='form.addParent()' class='ng-hide'>Add a parent</button>
			<button ng-click='form.addChild()'>Add a child</button>
			<button ng-click='form.addSibling()'>Add a sister</button>
		</form>"
	link: (scope, elm, attr) ->

app.controller 'FlexboxConfigCtrl', ($scope,flexboxConfigService) ->
	$scope.form = flexboxConfigService

app.factory 'flexboxConfigService', ($rootScope,$compile) ->
	$scope = $rootScope.$new(true)

	$scope.form = {}


	elm = attrs = undefined

	$scope.$watch 'form.column', (newValue) ->
		if newValue? and newValue is true
			attrs.$set('column','')
		else if newValue? and newValue is false
			attrs.$set('column')

	$scope.$watch 'form.flex', (newValue) ->
		if newValue? and newValue >= 0
			attrs.$set('flex',newValue)
		else if newValue? and not newValue >= 0
			attrs.$set('flex')

	angular.forEach ["align","justify","self"], (key) ->
		$scope.$watch "form.#{key}", (newValue) ->
			if newValue? and newValue.length > 0
				attrs.$set(key,newValue)
			if newValue? and not newValue.length > 0
				attrs.$set(key)

	$scope.addParent = ->
		if elm?
			parent = $compile(angular.element("<flexbox flex='1'><div class='hello'>Hello</div></flexbox>"))(elm.scope())
			parent[0].parentNode = elm[0].parentNode
			elm[0].parentNode = parent[0]

		return $scope

	$scope.addSibling = ->
		if elm?
			sibling = $compile(angular.element("<flexbox flex='1'><div class='hello'>Hello</div></flexbox>"))(elm.scope())
			elm.parent().prepend(sibling)

		return $scope

	$scope.addChild = ->
		if elm?
			child = $compile(angular.element("<flexbox flex='1'><div class='hello'>Hello</div></flexbox>"))(elm.scope())
			elm.prepend(child)

		return $scope

	$scope.open = (_elm_,_attrs_) ->
		if elm?
			elm.removeClass('selected')
		elm = _elm_
		elm.addClass('selected')
		attrs = _attrs_
		$scope._isOpen = true
		angular.forEach ["self", "align", "justify"], (key) ->
			if angular.isString(attrs.$attr[key])
				$scope.form[key] = elm.attr(key)
			else 
				$scope.form[key] = ''

		if angular.isString(attrs.$attr["flex"])
			$scope.form["flex"] = elm.attr("flex") >> 0
		else
			$scope.form["flex"] = null


		if angular.isString(attrs.$attr["column"])
			$scope.form["column"] = true
		else $scope.form['column'] = false

		return $scope

	$scope.close = ->
		$scope._isOpen = false

	$scope.isOpen = ->
		return !!$scope._isOpen

	return $scope






