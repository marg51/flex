app = angular.module 'uto.flexbox', []

app.directive 'flexbox', ->
	restrict: 'E'
	replace: true
	transclude: true
	template: '<div class="displayFlex" ng-transclude></div>'
