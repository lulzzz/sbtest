﻿'use strict';

common.directive('dateCtrl', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				model: "=model",
				min: "=?min",
				max: "=?max",
				disabled: "=disabled",
				name: "=name",
				required: "=required"
			},
			templateUrl: zionAPI.Web + 'Content/templates/datectrl.html?v=' + version,

			controller: ['$scope', function ($scope) {
			
				var dataSvc = {
					opened: false,
					
					readonly: $scope.disabled ? "readonly" : ""
				}
				$scope.data = dataSvc;
				$scope.readonly = $scope.disabled ? "readonly" : "";
				$scope.dateOptions = {
					minDate: $scope.min ? $scope.min : moment("01/01/1920", "MM/DD/YYYY").toDate(),
					maxDate: $scope.max ? $scope.max : moment("12/31/2050", "MM/DD/YYYY").toDate(),
					startingDay: 0,
					showWeeks: false,
				};
				
				$scope.formats = ['MM/dd/yyyy'];
				$scope.format = $scope.formats[0];
				$scope.getmoment = function (val) {
					return moment(val, $scope.format);
				}
				$scope.altInputFormats = ['M!/d!/yyyy'];
				$scope.today = function () {
					$scope.dt = new Date();
				};
				$scope.today();


				$scope.clear = function () {
					$scope.dt = null;
				};
				$scope.open = function ($event) {
					$event.preventDefault();
					$event.stopPropagation();
					$scope.data.opened = true;
				};
				$scope.isValid = function () {
					$scope.dateOptions.minDate = $scope.min ? $scope.min : moment("01/01/1920", "MM/DD/YYYY").toDate();
					$scope.dateOptions.maxDate = $scope.max ? $scope.max : moment("12/31/2050", "MM/DD/YYYY").toDate();
					if ($scope.required && !$scope.model) {
						return false;
					}						
					else if ($scope.model && $scope.model < $scope.dateOptions.minDate) {
						return false;
					}
					else if ($scope.model && $scope.model > $scope.dateOptions.maxDate) {
						return false;
					}
					else 
						return true;
				}

			}]
		}
	}
]);