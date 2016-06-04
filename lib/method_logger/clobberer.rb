module Clobberer
  extend self

  def run
    return unless ENV['COUNT_CALLS_TO']

    target_class.class_eval(patching_code)
  end

  private

  def parse_method_name
    instance_method? ? parse_instance_method : parse_class_method
  end

  def instance_method?
    ENV['COUNT_CALLS_TO'].include?("#")
  end

  def class_method?
    !instance_method?
  end

  def parse_instance_method
    ENV['COUNT_CALLS_TO'].split("#")
  end

  def parse_class_method
    ENV['COUNT_CALLS_TO'].split(".")
  end

  def patching_code
    "extend Logger; __add_logger :#{target_method}"
  end

  def target_class
    @target_class ||= Kernel.const_get(parse_method_name.first)
  end

  def target_method
    @target_method ||= parse_method_name.last.to_sym
  end
end
