# Copyright 2007 Walter Alini, Matías Bordese

#
# This file is part of biOps.
#
#     biOps is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     biOps is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with biOps; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#


#
#	Title: Miscelaneous R functions
#

# 
#	Function: error_range
#		Stops if a value is not in a given range.
# 
#	Parameters:
#		value_name - Variable's name to be printed.
#		value - Variable's value
#		min - Minimum acceptable value
#		max - Maximum acceptable value
#
.error_range <- function (value_name, value, min, max){
	if (value < min || value > max){
		stop(value_name, " must be between ", min, " and ", max, call. = FALSE)
	}
}

# 
#	Function: warning_range
#		Warns if a value is not in a given range.
# 
#	Parameters:
#		value_name - Variable's name to be printed.
#		value - Variable's value
#		min - Minimum acceptable value
#		max - Maximum acceptable value
#
.warning_range <- function (value_name, value, min, max){
	if (value < min || value > max){
		warning(value_name, " must be between ", min, " and ", max, call. = FALSE)
	}
}
