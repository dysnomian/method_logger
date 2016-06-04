module Reporter
  extend self

  def call_count
    @call_count ||= 0
  end

  def add_call
    @call_count ||= 0
    @call_count += 1
  end

  def report
    puts (ENV['COUNT_CALLS_TO'].to_s + call_count_string)
  end

  private

  def call_count_string
    case
    when call_count == 0 || call_count.nil?
      " was not called during execution.\n"
    when call_count == 1
      " was called 1 time.\n"
    when call_count > 1
      " was called #{call_count.to_s} times.\n"
    end
  end
end
