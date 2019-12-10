'use strict';

common.directive('contact', ['zionAPI','localStorageService','version',
	function (zionAPI, localStorageService, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				data: "=data",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				valGroup: "=?valGroup",
				showPrimary: "=?showPrimary"
			},
			templateUrl: zionAPI.Web + 'Content/templates/contact.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				if (!$scope.valGroup) {
					$scope.valGroup = "contact";
				}
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
common.directive('showErrors',['$timeout', function ($timeout) {
  	return {
  		restrict: 'A',
  		require: ['^form'],
  		link: function (scope, el, attrs, formCtrl) {
  			// find the text box element, which has the 'name' attribute
  			var inputEl = el[0].querySelector("[name]");
  			// convert the native text box element to an angular element
  			var inputNgEl = angular.element(inputEl);
  			// get the name on the text box so we know the property to check
  			// on the form controller
  			var inputName = inputNgEl.attr('name');

  			var validate = function () {
  				var f = null;
					if (angular.isArray(formCtrl)) {
						f = formCtrl[0];
					} else {
						f = formCtrl;
					}
  				var err = f[inputName].$error;

  				var targetMessage = (err.required) ? 'This ' + inputNgEl.attr('placeholder') + ' is required' : '';
  				targetMessage = (err.email) ? 'Invalid email' : targetMessage;
  				targetMessage = (err.url) ? 'Invalid website url' : targetMessage;
  				targetMessage = (err.number) ? 'Only number is allowed' : targetMessage;
  				targetMessage = (err.minlength) ? 'You must provide at least 20 characters for this field' : targetMessage;
  				targetMessage = (err.maxlength) ? 'You must not exceed the maximum of 200 characters for this field' : targetMessage;
  				targetMessage = (err.pattern) ? 'please enter a valid ' + inputNgEl.attr('placeholder') : targetMessage;

  				var bool = f[inputName].$invalid;
  				var errorEl = el[0].querySelector(".parsley-errors-list");
  				var errorNgE1 = angular.element(errorEl);
  				errorNgE1.remove();
  				inputNgEl.toggleClass('parsley-error', bool);
  				if (bool) {
  					var svg = angular.element('<p class="parsley-errors-list">' + targetMessage + '.</p>');
  					el.append(svg);
  				}
  			}

  			// only apply the has-error class after the user leaves the text box
  			inputNgEl.bind('blur', function () {
  				//validate();
				  
  			});
  			scope.$watch(function () {
				  return (formCtrl[0])[inputName].$invalid;
			  }, function (invalid) {
  				validate();
			  });
  		
		  }
  	}
}]);
common.directive('richTextEditor', function () {
	return {
		restrict: "A",
		require: 'ngModel',
		//replace : true,
		transclude: true,
		//template : '<div><textarea></textarea></div>',
		link: function (scope, element, attrs, ctrl) {

			var textarea = element.wysihtml5({ "html": true });

			var editor = textarea.data('wysihtml5').editor;

			// view -> model
			editor.on('change', function () {
				if (editor.getValue())
					scope.$apply(function () {
						ctrl.$setViewValue(editor.getValue());
					});
			});

			// model -> view
			ctrl.$render = function () {
				textarea.html(ctrl.$viewValue);
				editor.setValue(ctrl.$viewValue);
			};

			ctrl.$render();
		}
	};
});
common.directive('convertToNumber', function() {
	return {
		require: 'ngModel',
		link: function(scope, element, attrs, ngModel) {
            ngModel.$parsers.push(function (val) {
                return parseInt(val, 10);
			});
			ngModel.$formatters.push(function(val) {
				return '' + val;
			});
		}
	};
});
common.directive('convertToDecimal', function () {
	return {
		require: 'ngModel',
		link: function (scope, element, attrs, ngModel) {
			ngModel.$parsers.push(function (val) {
				return +val.toFixed(2);
			});
			ngModel.$formatters.push(function (val) {
				return '' + val;
			});
		}
	};
});
common.directive('convertToDecimal', function () {
	return {
		require: 'ngModel',
		link: function (scope, element, attrs, ngModel) {
			ngModel.$parsers.push(function (val) {
				return +parseFloat(val).toFixed(2);
			});
			ngModel.$formatters.push(function (val) {
				return '' + val;
			});
		}
	};
});
common.directive('confirmationNeeded', function () {
	return {
		priority: 1,
		terminal: true,
		link: function (scope, element, attr) {
			var msg = attr.confirmationNeeded || "Are you sure?";
			var clickAction = attr.ngClick;
			element.bind('click', function () {
				if (window.confirm(msg)) {
					scope.$eval(clickAction);
				}
			});
		}
	};
});

