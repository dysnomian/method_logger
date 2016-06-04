# Module to include in classes with a logged method.
module Logger
  def __add_logger(method_name)
    return unless method_defined?(method_name)
    return if __logged_method_exists?(method_name)

    # alias unlogged method to unlogged name
    alias_method __unlogged_method_name(method_name), method_name
    # define
    class_eval(__method_with_logger(method_name), __FILE__, __LINE__)
    # alias logged method to base method name
    alias_method method_name, __logged_method_name(method_name)

    self
  end

  private

  def __logged_method_exists?(method_name)
    method_defined?(__logged_method_name(method_name))
  end

  def __unlogged_method_name(method_name)
    method_name.to_s
      .concat("_unlogged")
      .to_sym
  end

  def __logged_method_name(method_name)
    method_name.to_s
      .concat("_logged")
      .to_sym
  end

  def __method_with_logger(method_name)
    "def #{__logged_method_name(method_name)}(*args, &block);
        Reporter.add_call;
        #{__unlogged_method_name(method_name)}(*args, &block);
      end;"
  end
end
