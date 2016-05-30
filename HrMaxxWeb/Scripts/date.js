/*global angular */
/*
 jQuery UI Datepicker plugin wrapper

 @note If ≤ IE8 make sure you have a polyfill for Date.toISOString()
 @param [ui-date] {object} Options to pass to $.fn.datepicker() merged onto uiDateConfig
 */

angular.module('ui.date', [])
	.constant('uiDateConfig', {})
	.directive('uiDate', [
		'uiDateConfig', function(uiDateConfig) {
			return {
				restrict: 'A',
				require: 'ngModel',
				link: function(scope, element, attrs, ngModelCtrl) {
					element.datepicker({
						dateFormat: 'd.m.yy',
						onSelect: function(date) {
							ngModelCtrl.$setViewValue(date);
						}
					});
				}
			};
		}
	]);