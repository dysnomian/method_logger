require "method_logger/reporter"
require "method_logger/clobberer"
require "method_logger/logger"

module MethodLogger
  VERSION = "0.0.0"

  def send_with_logging(message)
    Clobberer.run
    output = send(message)
    Reporter.report
    output
  end
end

module Kernel
  extend MethodLogger
end
