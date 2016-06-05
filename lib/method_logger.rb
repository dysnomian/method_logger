require "method_logger/reporter"
require "method_logger/clobberer"
require "method_logger/logger"

module MethodLogger
  VERSION = "0.0.0"
end

module Kernel
  extend MethodLogger
end
