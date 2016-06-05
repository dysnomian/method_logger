# Module to include in classes with a logged method.
# NOTE: I'm in the middle of modifying to accomodate class methods, which is
# turning out to be a more interesting problem that I expected going in. Some
# of this code was thought out on a 100 degree day with no AC, and I'm
# prepared for my approach to look very silly once it cools down this evening.
#
# I've flipflopped a bit on how to actually print the log. I wanted to tie in
# with pry so that it would log after executing a command, but that was out of
# scope. I settled on logging to stdout each time the method is called.
# In case it isn't abundantly clear, I found the method logger in the New Relic
# agent to be quite illuminating in approaching this problem. ^_^
module Logger
  def __add_logger(method_name, class_method=false)
    return unless method_defined?(method_name)
    return if __logged_method_exists?(method_name)

    # alias unlogged method to unlogged name
    alias_method __unlogged_method_name(method_name), method_name

    # define
    if class_method
      class_eval(__method_with_logger(method_name), __FILE__, __LINE__)
    else
      class_eval(__class_method_with_logger(method_name), __FILE__, __LINE__)
    end

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
        Reporter.report;
        #{__unlogged_method_name(method_name)}(*args, &block);
      end;"
  end

  def __class_method_with_logger(method_name)
    "def self.#{__logged_method_name(method_name)}(*args, &block);
        Reporter.add_call;
        Reporter.report;
        self.#{__unlogged_method_name(method_name)}(*args, &block);
      end;"
  end
end
