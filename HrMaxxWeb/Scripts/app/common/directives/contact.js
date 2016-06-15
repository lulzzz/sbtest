'use strict';

common.directive('contact', ['$modal', 'zionAPI','localStorageService',
	function ($modal, zionAPI, localStorageService) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				data: "=data",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				type: "=type"
			},
			templateUrl: zionAPI.Web + 'Content/templates/contact.html',

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				
				$scope.addAlert = function (error, type) {
					$scope.alerts = [];
					$scope.alerts.push({
						msg: error,
						type: type
					});
				};
				$scope.closeAlert = function (index) {
					$scope.alerts.splice(index, 1);
				};
				

				
			}]
		}
	}
]);

common.directive('bootstrapSwitch', [
        function() {
        	return {
        		restrict: 'A',
        		require: '?ngModel',
        		link: function (scope, element, attrs, ngModel) {
        			var options = {
        				onText: attrs.onText,
        				onColor: 'primary',
        				offColor: 'default',
        				offText: attrs.offText,
        				animate: true,
        			};
        			element.bootstrapSwitch(options);

        			element.on('switchChange.bootstrapSwitch', function(event, state) {
        				if (ngModel) {
        					scope.$apply(function() {
        						ngModel.$setViewValue(state);
        					});
        				}
        			});

        			scope.$watch(attrs.ngModel, function(newValue, oldValue) {
        				if (newValue) {
        					element.bootstrapSwitch('state', true, true);
        				} else {
        					element.bootstrapSwitch('state', false, true);
        				}
        			});
        		}
        	};
        }
]);

common.directive('showErrors', function () {
  	return {
  		restrict: 'A',
  		require: '^form',
  		link: function (scope, el, attrs, formCtrl) {
  			// find the text box element, which has the 'name' attribute
  			var inputEl = el[0].querySelector("[name]");
  			// convert the native text box element to an angular element
  			var inputNgEl = angular.element(inputEl);
  			// get the name on the text box so we know the property to check
  			// on the form controller
  			var inputName = inputNgEl.attr('name');

  			var validate = function () {
  				var err = formCtrl[inputName].$error;

  				var targetMessage = (err.required) ? 'This ' + inputNgEl.attr('placeholder') + ' is required' : '';
  				targetMessage = (err.email) ? 'Invalid email' : targetMessage;
  				targetMessage = (err.url) ? 'Invalid website url' : targetMessage;
  				targetMessage = (err.number) ? 'Only number is allowed' : targetMessage;
  				targetMessage = (err.minlength) ? 'You must provide at least 20 characters for this field' : targetMessage;
  				targetMessage = (err.maxlength) ? 'You must not exceed the maximum of 200 characters for this field' : targetMessage;
  				targetMessage = (err.pattern) ? 'please enter a valid ' + inputNgEl.attr('placeholder') : targetMessage;

  				var bool = formCtrl[inputName].$invalid;
  				var errorEl = el[0].querySelector(".parsley-errors-list");
  				var errorNgE1 = angular.element(errorEl);
  				errorNgE1.remove();
  				el.toggleClass('has-error', bool);
  				if (bool) {
  					var svg = angular.element('<p class="parsley-errors-list">' + targetMessage + '.</p>');
  					el.append(svg);
  				}
  			}

  			// only apply the has-error class after the user leaves the text box
  			inputNgEl.bind('keypressed keydown mouseenter blur change', function () {
  				scope.$apply(function () {
					  validate();
				  });
  			});
			  inputNgEl.load(function() {
			  	validate();
			  });
		  }
  	}
  });